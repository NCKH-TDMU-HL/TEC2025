import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/textfied.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _verificationId = "";
  bool _otpSent = false;
  bool _isLoading = false;
  int? _resendToken;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Định dạng số điện thoại Việt Nam
  String _formatPhoneNumber(String phone) {
    phone = phone.trim().replaceAll(' ', '').replaceAll('-', '');
    
    // Nếu bắt đầu bằng 0, thay thành +84
    if (phone.startsWith('0')) {
      return '+84${phone.substring(1)}';
    }
    
    // Nếu bắt đầu bằng 84, thêm +
    if (phone.startsWith('84')) {
      return '+$phone';
    }
    
    // Nếu không có mã quốc gia, thêm +84
    if (!phone.startsWith('+84')) {
      return '+84$phone';
    }
    
    return phone;
  }

  // Validate số điện thoại Việt Nam
  bool _isValidVietnamesePhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), ''); // Chỉ giữ số
    
    // Loại bỏ mã quốc gia để kiểm tra
    if (phone.startsWith('84')) {
      phone = phone.substring(2);
    }
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    
    // Kiểm tra định dạng: đầu số (3,5,7,8,9) + 8 số
    return RegExp(r'^[3|5|7|8|9][0-9]{8}$').hasMatch(phone);
  }

  // Gửi OTP
  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final formattedPhone = _formatPhoneNumber(_phoneController.text);
      
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Tự động xác thực (hiếm khi xảy ra trên Android)
          try {
            final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            await _updateUserProfile(userCredential.user);
            _showSnackBar("Đăng ký thành công!", isError: false);
            _navigateBack();
          } catch (e) {
            _showSnackBar("Lỗi đăng ký: ${e.toString()}", isError: true);
          }
        },
        
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = "Xác thực thất bại";
          
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = "Số điện thoại không hợp lệ";
              break;
            case 'too-many-requests':
              errorMessage = "Quá nhiều yêu cầu. Vui lòng thử lại sau";
              break;
            case 'quota-exceeded':
              errorMessage = "Đã vượt quá giới hạn SMS. Thử lại sau";
              break;
            default:
              errorMessage = "Lỗi: ${e.message}";
          }
          
          _showSnackBar(errorMessage, isError: true);
          setState(() => _isLoading = false);
        },
        
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _otpSent = true;
            _isLoading = false;
          });
          _showSnackBar("Mã OTP đã được gửi đến $formattedPhone", isError: false);
        },
        
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        
        forceResendingToken: _resendToken,
      );
      
    } catch (e) {
      _showSnackBar("Lỗi không xác định: ${e.toString()}", isError: true);
      setState(() => _isLoading = false);
    }
  }

  // Xác thực OTP
  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().length != 6) {
      _showSnackBar("Vui lòng nhập đủ 6 số OTP", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _updateUserProfile(userCredential.user);
      
      _showSnackBar("Đăng ký thành công! Chào mừng ${_nameController.text.trim()}", isError: false);
      _navigateBack();
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Xác thực OTP thất bại";
      
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = "Mã OTP không đúng";
          break;
        case 'session-expired':
          errorMessage = "Mã OTP đã hết hạn";
          break;
        case 'credential-already-in-use':
          errorMessage = "Số điện thoại đã được sử dụng";
          break;
        default:
          errorMessage = "Lỗi: ${e.message}";
      }
      
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar("Lỗi không xác định: ${e.toString()}", isError: true);
    }

    setState(() => _isLoading = false);
  }

  // Cập nhật thông tin user
  Future<void> _updateUserProfile(User? user) async {
    if (user != null && _nameController.text.trim().isNotEmpty) {
      await user.updateDisplayName(_nameController.text.trim());
      await user.reload(); // Refresh user data
    }
  }

  // Gửi lại OTP
  Future<void> _resendOTP() async {
    setState(() {
      _otpController.clear();
      _otpSent = false;
    });
    await _sendOTP();
  }

  // Điều hướng về trang trước
  void _navigateBack() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Họ tên
                CustomTextField(
                  controller: _nameController,
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    if (value.trim().length < 2) {
                      return 'Họ tên phải có ít nhất 2 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Số điện thoại
                CustomTextField(
                  controller: _phoneController,
                  labelText: "Số điện thoại (VD: 0987654321)",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (!_isValidVietnamesePhone(value)) {
                      return 'Số điện thoại không hợp lệ (VD: 0987654321)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Hiển thị số điện thoại
                if (_otpSent) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "OTP đã gửi đến: ${_formatPhoneNumber(_phoneController.text)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nhập OTP
                  CustomTextField(
                    controller: _otpController,
                    labelText: "Mã OTP (6 số)",
                    prefixIcon: Icons.sms,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập mã OTP';
                      }
                      if (value.length != 6) {
                        return 'Mã OTP phải có đúng 6 số';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Nút gửi lại OTP
                  TextButton.icon(
                    onPressed: _isLoading ? null : _resendOTP,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Gửi lại mã OTP"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Nút chính
                ElevatedButton(
                  onPressed: _isLoading ? null : (_otpSent ? _verifyOTP : _sendOTP),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _otpSent ? "Xác nhận OTP" : "Gửi mã OTP",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Bằng cách đăng ký, bạn đồng ý với điều khoản sử dụng của chúng tôi",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}