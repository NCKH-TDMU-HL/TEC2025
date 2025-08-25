import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  
  int _currentStep = 0; 

  void _sendCode() {
    if (_emailController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập email");
      return;
    }
    
    _showSnackBar("Mã xác thực đã được gửi tới email của bạn");
    setState(() {
      _currentStep = 1;
    });
  }

  void _verifyCode() {
    if (_codeController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập mã xác thực");
      return;
    }
    
    if (_codeController.text != "123456") {
      _showSnackBar("Mã xác thực không đúng");
      return;
    }
    
    setState(() {
      _currentStep = 2;
    });
  }

  void _changePassword() {
    if (_newPassController.text.isEmpty) {
      _showSnackBar("Vui lòng nhập mật khẩu mới");
      return;
    }

    if (_newPassController.text.length < 6) {
      _showSnackBar("Mật khẩu phải có ít nhất 6 ký tự");
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      _showSnackBar("Mật khẩu xác nhận không khớp");
      return;
    }

    _showSnackBar("Đổi mật khẩu thành công!");
    
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resendCode() {
    _showSnackBar("Mã xác thực mới đã được gửi");
  }

  void _backToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            Row(
              children: [
                _buildStepIndicator(0, "Email"),
                _buildStepLine(0),
                _buildStepIndicator(1, "Mã"),
                _buildStepLine(1),
                _buildStepIndicator(2, "Mật khẩu"),
              ],
            ),
            const SizedBox(height: 40),

            // Step content
            Expanded(
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    bool isActive = step <= _currentStep;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.grey[300],
          ),
          child: Icon(
            step == 0 ? Icons.email :
            step == 1 ? Icons.verified_user :
            Icons.lock,
            color: isActive ? Colors.white : Colors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isActive = step < _currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(top: 15),
        color: isActive ? Colors.blue : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildCodeStep();
      case 2:
        return _buildPasswordStep();
      default:
        return Container();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhập email của bạn",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Chúng tôi sẽ gửi mã xác thực tới email này",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _sendCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Gửi mã", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhập mã xác thực",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Mã xác thực đã được gửi tới ${_emailController.text}",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Mã xác thực",
            prefixIcon: Icon(Icons.verified_user),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _backToStep(0),
              child: const Text("Thay đổi email"),
            ),
            TextButton(
              onPressed: _resendCode,
              child: const Text("Gửi lại mã"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _verifyCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Xác thực", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tạo mật khẩu mới",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Vui lòng tạo mật khẩu mới có ít nhất 6 ký tự",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _newPassController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Mật khẩu mới",
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
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _changePassword,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Đổi mật khẩu", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}