import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _register() {
    // Kiểm tra validation
    if (_userController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập tài khoản");
      return;
    }

    if (_passController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập mật khẩu");
      return;
    }

    if (_passController.text != _confirmPassController.text) {
      _showSnackBar("Mật khẩu xác nhận không khớp");
      return;
    }

    if (_emailController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập email");
      return;
    }

    // Logic đăng ký thành công
    _showSnackBar("Đăng ký thành công!");

    // Quay lại trang login
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Tài khoản",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mật khẩu",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPassController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Xác nhận mật khẩu",
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Đăng ký", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
