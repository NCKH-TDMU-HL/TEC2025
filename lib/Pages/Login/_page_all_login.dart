import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/user_service.dart';
import '_page_register.dart';
import '_page_changepass.dart';
import '_page_login.dart';

class AllLoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const AllLoginPage({super.key, required this.onLoginSuccess});

  @override
  State<AllLoginPage> createState() => _AllLoginPageState();
}

class _AllLoginPageState extends State<AllLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();
  bool _isLoading = false;

  // Đăng nhập với Google
  Future<void> _loginWithGoogle(BuildContext context) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        widget.onLoginSuccess();
        await _userService.addHistory(
          userCredential.user!,
          "Đăng Ký Tài Khoản Băng Google",
          "Bạn vừa đăng nhập vào ứng dụng bằng tài khoản Google",
        );

        await _userService.addNotification(
          userCredential.user!,
          "Tạo tài khoản người dùng thành công",
          "Chào mừng bạn đã tới App Mass điện nước của chúng tôi! Rất mong bạn sẽ có một trảu nghiệm với app một cách trọn vẹn",
          "google",
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Chào mừng ${userCredential.user!.displayName ?? 'bạn'}!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng nhập Google thất bại: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              onPressed: _isLoading ? null : () => _loginWithGoogle(context),
              isLoading: _isLoading,
            ),
            const SizedBox(height: 15),

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
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LoginPage(onLoginSuccess: widget.onLoginSuccess),
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
                  onPressed: _isLoading ? null : () => _forgotPassword(context),
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => _register(context),
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ],
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(color: Colors.blue),
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
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : icon,
          ),
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
            side: backgroundColor == Colors.white
                ? const BorderSide(color: Colors.grey, width: 1)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          elevation: backgroundColor == Colors.white ? 1 : 2,
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

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
      height: 55,
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
