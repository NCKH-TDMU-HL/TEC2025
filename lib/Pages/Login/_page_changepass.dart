import 'package:flutter/material.dart';
import '../../widgets/textfied.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _emailFound = false;
  bool _showPasswordFields = false;

  void _checkEmail() {
    if (_emailController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập email", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      final emailToCheck = _emailController.text.trim().toLowerCase();
      
      bool foundUser = false;
      
      // Check demo admin
      if (!foundUser) {
        if (emailToCheck == "admin@test.com" || emailToCheck == "admin") {
          foundUser = true;
        }
      }

      if (foundUser) {
        setState(() {
          _emailFound = true;
          _showPasswordFields = true;
        });
        _showSnackBar("Email tìm thấy! Nhập mật khẩu mới bên dưới", isError: false);
      } else {
        _showSnackBar("Không tìm thấy tài khoản với email này", isError: true);
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _changePassword() {
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ mật khẩu mới", isError: true);
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showSnackBar("Mật khẩu phải có ít nhất 6 ký tự", isError: true);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar("Mật khẩu xác nhận không khớp", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      _showSuccessDialog();
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mật khẩu đã được thay đổi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mật khẩu của bạn đã được cập nhật thành công!"),
              const SizedBox(height: 12),
              Text(
                "Email: ${_emailController.text}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text("Bạn có thể đăng nhập với mật khẩu mới."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đổi mật khẩu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Nhập email để xác nhận tài khoản và đặt mật khẩu mới",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),
              
              if (!_emailFound)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
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
                        : const Text("Kiểm tra email", style: TextStyle(fontSize: 16)),
                  ),
                ),

              if (_showPasswordFields) ...[
                const SizedBox(height: 30),
                
                CustomTextField(
                  controller: _newPasswordController,
                  labelText: 'Mật khẩu mới',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                
                const SizedBox(height: 20),
                
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Xác nhận mật khẩu mới',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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
                        : const Text("Đổi mật khẩu", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
              
              const SizedBox(height: 30),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          "Hướng dẫn:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("1. Nhập email để kiểm tra tài khoản"),
                    Text("2. Nhập mật khẩu mới (ít nhất 6 ký tự)"),
                    Text("3. Xác nhận mật khẩu mới"),
                    SizedBox(height: 12),
                    Text(
                      "Demo accounts:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      "• admin@test.com hoặc admin",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      "• Hoặc bất kỳ email nào đã đăng ký",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
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