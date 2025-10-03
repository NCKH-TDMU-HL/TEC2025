import 'package:flutter/material.dart';
import '../../controller/register_controller.dart';
import '../../widgets/register_form_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateBack() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _onSendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.sendOTP(_showSnackBar);
  }

  Future<void> _onVerifyOTP() async {
    await _controller.verifyOTP(_showSnackBar, _navigateBack);
  }

  Future<void> _onResendOTP() async {
    await _controller.resendOTP(_showSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RegisterFormWidget(
          controller: _controller,
          formKey: _formKey,
          onSendOTP: _onSendOTP,
          onVerifyOTP: _onVerifyOTP,
          onResendOTP: _onResendOTP,
        ),
      ),
    );
  }
}