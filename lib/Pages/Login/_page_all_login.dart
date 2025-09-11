import 'package:flutter/material.dart';
import '_page_register.dart';
import '_page_changepass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '_page_login.dart';

class AllLoginPage extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const AllLoginPage({super.key, required this.onLoginSuccess});

  void _loginWithGoogle(BuildContext context) {
    onLoginSuccess();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập bằng Google thành công")),
    );
  }

  void _loginWithApple(BuildContext context) {
    onLoginSuccess();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập bằng Apple thành công")),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Chào mừng bạn!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Google login
            _SocialButton(
              text: "Đăng nhập bằng Google",
              icon: SvgPicture.asset('lib/assets/icon_google.svg'),
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () => _loginWithGoogle(context),
            ),
            const SizedBox(height: 15),

            // Apple login
            _SocialButton(
              text: "Đăng nhập bằng Apple",
              icon: const Icon(Icons.apple, size: 28, color: Colors.white),
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () => _loginWithApple(context),
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

            // Login bằng tài khoản
            _MainButton(
              text: "Đăng nhập bằng tài khoản",
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(onLoginSuccess: onLoginSuccess),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // Quên mật khẩu + Đăng ký
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _forgotPassword(context),
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () => _register(context),
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 16, color: Colors.green),
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

class _SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55, // Chiều cao đồng bộ
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(
          width: 30,
          height: 30,
          child: Center(child: icon),
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _MainButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55, // Đồng bộ với SocialButton
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
