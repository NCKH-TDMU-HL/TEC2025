import 'package:firebase_auth/firebase_auth.dart';
import '../model/phone_validation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Gửi OTP
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
    int? forceResendingToken,
  }) async {
    final formattedPhone = PhoneValidation.formatPhoneNumber(phoneNumber);

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: forceResendingToken,
    );
  }

  // Xác thực OTP
  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Cập nhật thông tin user
  Future<void> updateUserProfile(User? user, String displayName) async {
    if (user != null && displayName.trim().isNotEmpty) {
      await user.updateDisplayName(displayName.trim());
      await user.reload(); // Refresh user data
    }
  }

  // Lấy thông báo lỗi dễ hiểu
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return "Số điện thoại không hợp lệ";
      case 'too-many-requests':
        return "Quá nhiều yêu cầu. Vui lòng thử lại sau";
      case 'quota-exceeded':
        return "Đã vượt quá giới hạn SMS. Thử lại sau";
      case 'invalid-verification-code':
        return "Mã OTP không đúng";
      case 'session-expired':
        return "Mã OTP đã hết hạn";
      case 'credential-already-in-use':
        return "Số điện thoại đã được sử dụng";
      default:
        return "Đã xảy ra lỗi, vui lòng thử lại";
    }
  }
}