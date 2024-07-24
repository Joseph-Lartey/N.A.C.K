import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  final int? userId;

  const ChangePasswordPage({Key? key, required this.userId}) : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _doPasswordsMatch = true;

  bool _isSubmitDisabled = true; // Initially disable submit button

  void _validatePassword(String password) {
    setState(() {
      _isMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });

    _checkAllRequirements();
  }

  void _validatePasswordsMatch(String confirmPassword) {
    setState(() {
      _doPasswordsMatch = _newPasswordController.text == confirmPassword;
    });

    _checkAllRequirements();
  }

  void _checkAllRequirements() {
    setState(() {
      _isSubmitDisabled = !(_isMinLength &&
          _hasUppercase &&
          _hasLowercase &&
          _hasNumber &&
          _hasSpecialChar &&
          _doPasswordsMatch);
    });
  }

Future<void> _handleSubmit() async {
  final userId = widget.userId;
  final currentPassword = _currentPasswordController.text;
  final newPassword = _newPasswordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User ID not found.'),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }

  if (!(_doPasswordsMatch && !_isSubmitDisabled)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passwords do not match or do not meet requirements.'),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }

  final url = 'http://16.171.150.101/N.A.C.K/backend/users/change_password';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'oldPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }),
  );

  // Debugging: log the response body
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        duration: Duration(seconds: 3),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to change password: ${response.body}'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Clear form fields or perform any other necessary cleanup
  _currentPasswordController.clear();
  _newPasswordController.clear();
  _confirmPasswordController.clear();
  setState(() {
    _isMinLength = false;
    _hasUppercase = false;
    _hasLowercase = false;
    _hasNumber = false;
    _hasSpecialChar = false;
    _doPasswordsMatch = true;
    _isSubmitDisabled = true; // Disable submit button again
  });
}


  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                ),
                labelText: 'Current Password',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              onChanged: _validatePassword,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                ),
                labelText: 'New Password',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              onChanged: _validatePasswordsMatch,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                ),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (!_doPasswordsMatch)
              const Text(
                'Both passwords must match',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 20),
            const Text(
              'Password must contain:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PasswordRequirement(
              text: 'Min 8 Characters',
              isMet: _isMinLength,
            ),
            PasswordRequirement(
              text: 'Upper-case Letter',
              isMet: _hasUppercase,
            ),
            PasswordRequirement(
              text: 'Lower-case Letter',
              isMet: _hasLowercase,
            ),
            PasswordRequirement(
              text: 'Number',
              isMet: _hasNumber,
            ),
            PasswordRequirement(
              text: 'Special Character',
              isMet: _hasSpecialChar,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitDisabled ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: _isSubmitDisabled
                      ? Colors.grey
                      : const Color.fromARGB(255, 183, 66, 91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

class PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordRequirement({
    Key? key,
    required this.text,
    required this.isMet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.cancel,
          color: isMet ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }
}
