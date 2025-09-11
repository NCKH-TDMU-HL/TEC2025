// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Đã xóa Firebase import
import '_page_changepass.dart';
import '../../widgets/textfied.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  // Đăng nhập demo/local (mở rộng được)
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ email và mật khẩu");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate loading time
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Demo login logic - có thể mở rộng thêm nhiều tài khoản
      if (_emailController.text.trim().toLowerCase() == "admin@test.com" && _passController.text == "123456" ||
          _emailController.text.trim() == "admin" && _passController.text == "123456") {
        
        _showSnackBar("Đăng nhập thành công! Chào mừng ${_emailController.text}");
        widget.onLoginSuccess();
        Navigator.pop(context);
        
      } else {
        _showSnackBar("Email hoặc mật khẩu không chính xác");
      }
      
    } catch (e) {
      _showSnackBar('Có lỗi xảy ra: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains("thành công") ? Colors.green : Colors.red,
      ),
    );
  }

  void _forgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Chào Mừng Bạn!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),

            // Email/Username
            CustomTextField(
              controller: _emailController,
              labelText: "Email hoặc Tên đăng nhập",
              prefixIcon: Icons.person,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),

            // Mật Khẩu
            CustomTextField(
              controller: _passController,
              labelText: "Mật Khẩu",
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Quên mật khẩu
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _forgotPassword(context),
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // Button đăng nhập
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
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
                    : const Text(
                        "Đăng Nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}