import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 66, 91), // Set entire page background color
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0, // Push the image up more
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 150.0, // Increase the height of the image
                ),
              ),
              const SizedBox(height: 20.0), // Adjust spacing between image and text
              const Text(
                'N.A.C.K is a dating app designed for the Ashesi community, dedicated to helping students find meaningful connections and love. This platform fosters a supportive environment where individuals can explore relationships, share interests, and build lasting connections within their campus community and beyond.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0, // Increase font size for better readability
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 500.0), // Adjust the height for ample scrolling space
            ],
          ),
        ),
      ),
    );
  }
}
