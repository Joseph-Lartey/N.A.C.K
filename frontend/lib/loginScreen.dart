import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 183, 66, 91), // Background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            color: Color.fromARGB(255, 183, 66, 91), // Background color
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
              
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                    const SizedBox(height: 10,),
                    const Text(
                      'Welcome back, Sign in using your social \n           or email to continue with us',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 125, 116, 116),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Email (Ashesi email)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 66, 91),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 63,
                      width: 327,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 183, 66, 91), // Button color
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0), // Add padding for better touch response
                    child: Text(
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
        ],
      ),
    );
  }
}
