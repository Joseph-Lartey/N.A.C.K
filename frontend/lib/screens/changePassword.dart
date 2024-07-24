import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

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

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

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

  void _handleSubmit() {
    // Perform password change logic here (simulate success)
    // For demonstration purposes, we'll just show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        duration: Duration(seconds: 3),
      ),
    );

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _currentPasswordController,
              obscureText: !_currentPasswordVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _currentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentPasswordVisible = !_currentPasswordVisible;
                    });
                  },
                ),
                labelText: 'Current Password',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: !_newPasswordVisible,
              onChanged: _validatePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                ),
                labelText: 'New Password',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 66, 91),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_confirmPasswordVisible,
              onChanged: _validatePasswordsMatch,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
