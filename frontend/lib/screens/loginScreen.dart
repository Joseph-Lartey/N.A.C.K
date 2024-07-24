import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'homePage.dart';
import 'forgottenPassword.dart'; // Import the ResetPasswordPage
import 'WelcomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkButtonState);
    _passwordController.addListener(_checkButtonState);
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    RegExp hasUppercase = RegExp(r'[A-Z]');
    RegExp hasLowercase = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!hasUppercase.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit.hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void _loginRequest(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.login(_emailController.text, _passwordController.text);

      if (authProvider.loginSuccess == false) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "Wrong email or password",
        );
      } else {
        Navigator.push(
          context,
          _createRoute(const HomePage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 183, 66, 91),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );

          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 183, 66, 91),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login to  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              "N.A.C.K",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color.fromARGB(255, 183, 66, 91),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Welcome back, Sign in using your social \n           or email to continue with us',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 125, 116, 116),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: _validateEmail,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 183, 66, 91),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              validator: _validatePassword,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                ),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 183, 66, 91),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () => _loginRequest(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: _isButtonEnabled
                              ? const Color.fromARGB(255, 183, 66, 91)
                              : Colors.grey,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createRoute(const ResetPasswordPage()), // Navigate to ResetPasswordPage
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 183, 66, 91),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
