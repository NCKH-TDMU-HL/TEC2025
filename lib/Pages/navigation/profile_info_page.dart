import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

  User? get currentUser => FirebaseAuth.instance.currentUser;

  String get displayName {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    if (currentUser?.email != null) {
      return currentUser!.email!.split('@')[0];
    }
    if (currentUser?.phoneNumber != null) {
      return currentUser!.phoneNumber!;
    }
    return "Người dùng";
  }

  String get loginInfo {
    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      return currentUser!.email!;
    }
    if (currentUser?.phoneNumber != null && currentUser!.phoneNumber!.isNotEmpty) {
      return currentUser!.phoneNumber!;
    }
    return "Chưa cập nhật";
  }

  String get loginType {
    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      bool isGoogleAccount = currentUser!.providerData
          .any((provider) => provider.providerId == 'google.com');
      
      if (isGoogleAccount) {
        return "Google";
      } else {
        return "Email";
      }
    }
    
    if (currentUser?.phoneNumber != null && currentUser!.phoneNumber!.isNotEmpty) {
      return "Số điện thoại";
    }
    
    return "Khách";
  }

  String get accountStatus {
    if (currentUser?.emailVerified == true) {
      return "Đã xác thực email";
    }
    if (currentUser?.phoneNumber != null) {
      return "Đã xác thực số điện thoại";
    }
    return "Chưa xác thực";
  }

  String get joinDate {
    if (currentUser?.metadata.creationTime != null) {
      final date = currentUser!.metadata.creationTime!;
      return "${date.day}/${date.month}/${date.year}";
    }
    return "Không xác định";
  }

  String get lastSignIn {
    if (currentUser?.metadata.lastSignInTime != null) {
      final date = currentUser!.metadata.lastSignInTime!;
      return "${date.day}/${date.month}/${date.year}";
    }
    return "Không xác định";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
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
                                return Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.blue[700],
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              size: 70,
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      loginType,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Information cards
            _buildInfoCard(
              title: "Thông tin tài khoản",
              items: [
                _InfoItem("Tên hiển thị", displayName),
                _InfoItem("Đăng nhập bằng", loginType),
                _InfoItem(
                  currentUser?.email != null ? "Email" : "Số điện thoại",
                  loginInfo,
                ),
                _InfoItem("Trạng thái", accountStatus),
              ],
            ),
            
            const SizedBox(height: 20),
            
            _buildInfoCard(
              title: "Thống kê tài khoản",
              items: [
                _InfoItem("Ngày tham gia", joinDate),
                _InfoItem("Lần đăng nhập cuối", lastSignIn),
                _InfoItem("ID tài khoản", currentUser?.uid ?? "N/A"),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showEditDialog(context),
                icon: const Icon(Icons.edit),
                label: const Text("Chỉnh sửa thông tin"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showSecurityInfo(context),
                icon: const Icon(Icons.security),
                label: const Text("Thông tin bảo mật"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<_InfoItem> items,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildInfoRow(item.label, item.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: currentUser?.displayName ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chỉnh sửa thông tin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tên hiển thị",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await currentUser?.updateDisplayName(nameController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cập nhật thành công!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Lỗi: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _showSecurityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông tin bảo mật"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityRow("Xác thực 2 bước", currentUser?.phoneNumber != null ? "Đã bật" : "Chưa bật"),
            _buildSecurityRow("Email xác thực", currentUser?.emailVerified == true ? "Đã xác thực" : "Chưa xác thực"),
            _buildSecurityRow("Phương thức đăng nhập", loginType),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              color: value.contains("Đã") ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}