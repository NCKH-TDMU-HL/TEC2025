import '../model/phone_validation.dart';

class FormValidators {
  // Validator cho tên
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }
    return null;
  }

  // Validator cho số điện thoại
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (!PhoneValidation.isValidVietnamesePhone(value)) {
      return 'Số điện thoại không hợp lệ (VD: 0987654321)';
    }
    return null;
  }

  // Validator cho OTP
  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mã OTP';
    }
    if (value.length != 6) {
      return 'Mã OTP phải có đúng 6 số';
    }
    return null;
  }
}