import 'package:flutter/material.dart';
import '_page_register.dart';
import '_page_changepass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '_page_login.dart';

class AllLoginPage extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const AllLoginPage({super.key, required this.onLoginSuccess});

  void _loginWithGoogle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập bằng Google")),
    );
  }

  void _loginWithApple(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập bằng Apple")),
    );
  }

  void _register(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
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
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Chào mừng bạn!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Google login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _loginWithGoogle(context),
                icon: SvgPicture.asset(
                  'lib/assets/icon_google.svg',
                  width: 35,
                  height: 35,
                ),
                label: const Text("Đăng nhập bằng Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Apple login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _loginWithApple(context),
                icon: const Icon(Icons.apple, size: 35),
                label: const Text("Đăng nhập bằng Apple"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("hoặc"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),

            // Mở LoginPage
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(
                        onLoginSuccess: onLoginSuccess,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Đăng nhập bằng tài khoản"),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _forgotPassword(context),
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () => _register(context),
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
