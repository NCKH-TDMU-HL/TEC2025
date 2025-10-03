class PhoneValidation {
  // Định dạng số điện thoại Việt Nam
  static String formatPhoneNumber(String phone) {
    phone = phone.trim().replaceAll(' ', '').replaceAll('-', '');

    // Nếu bắt đầu bằng 0, thay thành +84
    if (phone.startsWith('0')) {
      return '+84${phone.substring(1)}';
    }

    // Nếu bắt đầu bằng 84, thêm +
    if (phone.startsWith('84')) {
      return '+$phone';
    }

    // Nếu không có mã quốc gia, thêm +84
    if (!phone.startsWith('+84')) {
      return '+84$phone';
    }

    return phone;
  }

  // Validate số điện thoại Việt Nam
  static bool isValidVietnamesePhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), ''); // Chỉ giữ số

    // Loại bỏ mã quốc gia để kiểm tra
    if (phone.startsWith('84')) {
      phone = phone.substring(2);
    }
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    // Kiểm tra định dạng: đầu số (3,5,7,8,9) + 8 số
    return RegExp(r'^[3|5|7|8|9][0-9]{8}$').hasMatch(phone);
  }
}