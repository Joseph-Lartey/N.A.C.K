import 'package:flutter/material.dart';
import 'interests.dart';
import 'loginScreen.dart'; // Import the InterestsPage

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_checkButtonState);
    _lastNameController.addListener(_checkButtonState);
    _emailController.addListener(_checkButtonState);
    _passwordController.addListener(_checkButtonState);
    _confirmPasswordController.addListener(_checkButtonState);
    _dobController.addListener(_checkButtonState);
    _classController.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _classController.dispose();
    super.dispose();
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _classController.text.isNotEmpty;
    });
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
        backgroundColor: const Color.fromARGB(255, 183, 66, 91), // Background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Pop the current screen
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 183, 66, 91), // Background color
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
                    vertical: 30.0,
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
                              "Sign Up to  ",
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
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: TextField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.check,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 183, 66, 91),
                                  ),
                                ),
                                onChanged: (_) {
                                  _checkButtonState();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.check,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 183, 66, 91),
                                  ),
                                ),
                                onChanged: (_) {
                                  _checkButtonState();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          labelText: 'Email (Ashesi email)',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _classController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.school,
                            color: Colors.grey,
                          ),
                          labelText: 'Class',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                        onChanged: (_) {
                          _checkButtonState();
                        },
                      ),
                      const SizedBox(height: 60),
                      GestureDetector(
                        onTap: _isButtonEnabled
                            ? () {
                                Navigator.push(
                                  context,
                                  _createRoute(InterestsPage()),
                                );
                              }
                            : null,
                        child: Container(
                          height: 63,
                          width: 327,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _isButtonEnabled
                                ? const Color.fromARGB(255, 183, 66, 91)
                                : Colors.grey, // Adjusted color based on state
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createRoute(const LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding for better touch response
                          child: const Text(
                            "Have an account already?  Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 183,                               66, 91),
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

