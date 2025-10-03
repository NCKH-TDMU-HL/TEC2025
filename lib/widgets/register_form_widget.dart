import 'package:flutter/material.dart';
import '../controller/register_controller.dart';
import '../util/form_validators.dart';
import '../model/phone_validation.dart';
import '../widgets/textfied.dart';

class RegisterFormWidget extends StatelessWidget {
  final RegisterController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSendOTP;
  final VoidCallback onVerifyOTP;
  final VoidCallback onResendOTP;

  const RegisterFormWidget({
    super.key,
    required this.controller,
    required this.formKey,
    required this.onSendOTP,
    required this.onVerifyOTP,
    required this.onResendOTP,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Tạo tài khoản mới",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Họ tên
            CustomTextField(
              controller: controller.nameController,
              labelText: "Họ và tên",
              prefixIcon: Icons.person,
              validator: FormValidators.validateName,
            ),
            const SizedBox(height: 20),

            // Số điện thoại
            CustomTextField(
              controller: controller.phoneController,
              labelText: "Số điện thoại (VD: 0987654321)",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: FormValidators.validatePhone,
            ),
            const SizedBox(height: 20),

            // OTP Section
            if (controller.otpSent) ...[
              _buildOTPSentInfo(),
              const SizedBox(height: 20),
              _buildOTPInput(),
              const SizedBox(height: 10),
              _buildResendButton(),
              const SizedBox(height: 20),
            ],

            // Main Action Button
            _buildMainButton(),
            const SizedBox(height: 20),

            // Terms
            const Text(
              "Bằng cách đăng ký, bạn đồng ý với điều khoản sử dụng của chúng tôi",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPSentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "OTP đã gửi đến: ${PhoneValidation.formatPhoneNumber(controller.phoneController.text)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPInput() {
    return CustomTextField(
      controller: controller.otpController,
      labelText: "Mã OTP (6 số)",
      prefixIcon: Icons.sms,
      keyboardType: TextInputType.number,
      maxLength: 6,
      validator: FormValidators.validateOTP,
    );
  }

  Widget _buildResendButton() {
    return TextButton.icon(
      onPressed: controller.isLoading ? null : onResendOTP,
      icon: const Icon(Icons.refresh),
      label: const Text("Gửi lại mã OTP"),
      style: TextButton.styleFrom(foregroundColor: Colors.green),
    );
  }

  Widget _buildMainButton() {
    return ElevatedButton(
      onPressed: controller.isLoading
          ? null
          : (controller.otpSent ? onVerifyOTP : onSendOTP),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: controller.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              controller.otpSent ? "Xác nhận OTP" : "Gửi mã OTP",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}