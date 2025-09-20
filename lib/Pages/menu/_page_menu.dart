import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navigation/profile_info_page.dart';

class MenuPage extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const MenuPage({super.key, this.onLogout});

  // Lấy thông tin user từ Firebase
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Lấy tên hiển thị
  String get displayName {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    // Nếu đăng nhập bằng email, lấy phần trước @
    if (currentUser?.email != null) {
      return currentUser!.email!.split('@')[0];
    }
    // Nếu đăng nhập bằng SĐT, hiển thị số điện thoại luôn
    if (currentUser?.phoneNumber != null) {
      return currentUser!.phoneNumber!; // Hiển thị số điện thoại trực tiếp
    }
    return "Người dùng";
  }

  // Lấy thông tin đăng nhập - Hiển thị email nếu đăng nhập bằng Google/Email, SĐT nếu đăng nhập bằng phone
  String get loginInfo {
    // Ưu tiên hiển thị email nếu có (Google/Email login)
    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      return currentUser!.email!;
    }
    // Nếu không có email, hiển thị số điện thoại (Phone login)
    if (currentUser?.phoneNumber != null && currentUser!.phoneNumber!.isNotEmpty) {
      return currentUser!.phoneNumber!;
    }
    return "Chưa cập nhật";
  }

  // Xác định loại đăng nhập
  String get loginType {
    // Kiểm tra Google login (thường có email)
    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      // Kiểm tra xem có phải Google account không
      bool isGoogleAccount = currentUser!.providerData
          .any((provider) => provider.providerId == 'google.com');
      
      if (isGoogleAccount) {
        return "Google";
      } else {
        return "Email";
      }
    }
    
    // Phone number login
    if (currentUser?.phoneNumber != null && currentUser!.phoneNumber!.isNotEmpty) {
      return "Số điện thoại";
    }
    
    return "Khách";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Phần 1 - User Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar với ảnh thực từ Google hoặc icon mặc định
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      child: ClipOval(
                        child: currentUser?.photoURL != null
                            ? Image.network(
                                currentUser!.photoURL!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback nếu không load được ảnh
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blue[700],
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                },
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.blue[700],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Hiển thị thông tin đăng nhập
                    Text(
                      loginInfo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Text(
                        loginType, // Chỉ hiển thị loại đăng nhập
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(
                thickness: 1,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              
              // Phần 2 - Settings
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cài đặt & Thông tin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Thông tin cá nhân',
                      subtitle: 'Cập nhật thông tin của bạn',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileInfoPage(),
                          ),
                        );
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.security,
                      title: 'Bảo mật',
                      subtitle: currentUser?.email != null 
                          ? 'Đổi mật khẩu, xác thực 2 bước'
                          : 'Cài đặt bảo mật tài khoản',
                      onTap: () {
                        // Navigate to security
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Thông báo',
                      subtitle: 'Cài đặt thông báo và nhắc nhở',
                      onTap: () {
                        // Navigate to notifications
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.payment,
                      title: 'Phương thức thanh toán',
                      subtitle: 'Quản lý thẻ và tài khoản ngân hàng',
                      onTap: () {
                        // Navigate to payment
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.language,
                      title: 'Ngôn ngữ',
                      subtitle: 'Tiếng Việt',
                      onTap: () {
                        // Navigate to language
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.palette_outlined,
                      title: 'Giao diện',
                      subtitle: 'Chế độ sáng/tối, màu sắc',
                      onTap: () {
                        // Navigate to theme
                      },
                    ),
                  ],
                ),
              ),
              
              Divider(
                thickness: 1,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              
              // Phần 3 - Support
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hỗ trợ & Tài khoản',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Trung tâm trợ giúp',
                      subtitle: 'Câu hỏi thường gặp, hướng dẫn',
                      onTap: () {
                        // Navigate to help center
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.feedback_outlined,
                      title: 'Khiếu nại & Phản hồi',
                      subtitle: 'Gửi khiếu nại, góp ý cải thiện',
                      onTap: () {
                        // Navigate to feedback
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Về ứng dụng',
                      subtitle: 'Phiên bản 1.0.0',
                      onTap: () {
                        _showAppInfoDialog(context);
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Chính sách bảo mật',
                      subtitle: 'Điều khoản sử dụng và quyền riêng tư',
                      onTap: () {
                        // Navigate to privacy policy
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          foregroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red[200]!),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Đăng xuất',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Đăng xuất khỏi Firebase
                await FirebaseAuth.instance.signOut();
                
                if (onLogout != null) {
                  onLogout!();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Về ứng dụng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Ứng dụng phiên bản 1.0.0\n\nĐây là ứng dụng mẫu sử dụng Flutter và Firebase.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}