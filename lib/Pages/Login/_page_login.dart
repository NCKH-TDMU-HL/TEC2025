import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/textfied.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  String _verificationId = "";
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
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
    
    //thêm +84
    if (!phone.startsWith('+84')) {
      return '+84$phone';
    }
    
    return phone;
  }

  //số điện thoại Việt Nam
  bool _isValidVietnamesePhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Loại bỏ mã quốc gia để kiểm tra
    if (phone.startsWith('84')) {
      phone = phone.substring(2);
    }
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    
    // Kiểm tra định dạng
    return RegExp(r'^[3|5|7|8|9][0-9]{8}$').hasMatch(phone);
  }

  // Gửi OTP
  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar("Vui lòng nhập số điện thoại", isError: true);
      return;
    }

    if (!_isValidVietnamesePhone(_phoneController.text)) {
      _showSnackBar("Số điện thoại không hợp lệ (VD: 0987654321)", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedPhone = _formatPhoneNumber(_phoneController.text);
      
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Tự động đăng nhập
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            _showSnackBar("Đăng nhập thành công!", isError: false);
            widget.onLoginSuccess();
            if (!mounted) return;
            Navigator.pop(context);
          } catch (e) {
            _showSnackBar("Lỗi đăng nhập: ${e.toString()}", isError: true);
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
            case 'user-disabled':
              errorMessage = "Tài khoản đã bị vô hiệu hóa";
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
            _otpSent = true;
            _isLoading = false;
          });
          _showSnackBar("Mã OTP đã được gửi đến $formattedPhone", isError: false);
        },
        
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
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

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      _showSnackBar("Đăng nhập thành công!", isError: false);
      
      // quay về trang trước
      widget.onLoginSuccess();
      if (!mounted) return;
      Navigator.pop(context);
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Xác thực OTP thất bại";
      
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = "Mã OTP không đúng";
          break;
        case 'session-expired':
          errorMessage = "Mã OTP đã hết hạn";
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

  // Gửi lại OTP
  Future<void> _resendOTP() async {
    setState(() {
      _otpController.clear();
      _otpSent = false;
    });
    await _sendOTP();
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
        title: const Text("Đăng nhập"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Chào Mừng Bạn!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Đăng nhập bằng số điện thoại",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),

              // Số điện thoại
              AbsorbPointer(
                absorbing: _otpSent, // Disable khi đã gửi OTP
                child: Opacity(
                  opacity: _otpSent ? 0.6 : 1.0,
                  child: CustomTextField(
                    controller: _phoneController,
                    labelText: "Số điện thoại (VD: 0987654321)",
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Hiển thị thông tin sau khi gửi OTP
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
                ),
                const SizedBox(height: 10),

                // Nút gửi lại OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _isLoading ? null : _resendOTP,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("Gửi lại OTP"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),

              // Nút chính
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_otpSent ? _verifyOTP : _sendOTP),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Thông tin hỗ trợ
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Lưu ý:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "• Nhập số điện thoại bắt đầu bằng 03, 05, 07, 08, 09\n• Mã OTP sẽ được gửi qua SMS\n• Mã OTP có hiệu lực trong 60 giây",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}