import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import '../service/user_service.dart';
import '../model/phone_validation.dart';

class RegisterController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String _verificationId = "";
  bool _otpSent = false;
  bool _isLoading = false;
  int? _resendToken;

  // Getters
  bool get otpSent => _otpSent;
  bool get isLoading => _isLoading;
  String get verificationId => _verificationId;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Gửi OTP
  Future<void> sendOTP(Function(String, {required bool isError}) showMessage) async {
    _setLoading(true);

    try {
      await _authService.sendOTP(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _handleAutoVerification(credential, showMessage);
        },
        verificationFailed: (FirebaseAuthException e) {
          final errorMessage = AuthService.getErrorMessage(e.code);
          showMessage(errorMessage, isError: true);
          _setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _otpSent = true;
          _setLoading(false);
          
          final formattedPhone = PhoneValidation.formatPhoneNumber(phoneController.text);
          showMessage("Mã OTP đã được gửi đến $formattedPhone", isError: false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      showMessage("Lỗi không xác định: ${e.toString()}", isError: true);
      _setLoading(false);
    }
  }

  // Xác thực OTP
  Future<void> verifyOTP(
    Function(String, {required bool isError}) showMessage,
    VoidCallback onSuccess,
  ) async {
    if (otpController.text.trim().length != 6) {
      showMessage("Vui lòng nhập đủ 6 số OTP", isError: true);
      return;
    }

    _setLoading(true);

    try {
      final userCredential = await _authService.verifyOTP(
        verificationId: _verificationId,
        smsCode: otpController.text.trim(),
      );

      await _authService.updateUserProfile(
        userCredential.user,
        nameController.text.trim(),
      );

      if (userCredential.user != null) {
        await _userService.addHistory(
          userCredential.user!,
          "Đăng nhập",
          "Đăng ký bằng số điện thoại",
        );
        await _userService.addNotification(
          userCredential.user!,
          "Tạo tài khoản người dùng thành công",
          "Bạn đã đăng ký thành công bằng số điện thoại 🎉",
          "Phone",
        );
      }

      showMessage(
        "Đăng ký thành công! Chào mừng ${nameController.text.trim()}",
        isError: false,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthService.getErrorMessage(e.code);
      showMessage(errorMessage, isError: true);
    } catch (e) {
      showMessage("Lỗi không xác định: ${e.toString()}", isError: true);
    }

    _setLoading(false);
  }

  // Gửi lại OTP
  Future<void> resendOTP(Function(String, {required bool isError}) showMessage) async {
    otpController.clear();
    _otpSent = false;
    notifyListeners();
    await sendOTP(showMessage);
  }

  // Xử lý tự động xác thực
  Future<void> _handleAutoVerification(
    PhoneAuthCredential credential,
    Function(String, {required bool isError}) showMessage,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _authService.updateUserProfile(userCredential.user, nameController.text.trim());
      showMessage("Đăng ký thành công!", isError: false);
    } catch (e) {
      showMessage("Lỗi đăng ký: ${e.toString()}", isError: true);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
