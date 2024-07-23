import 'package:flutter/material.dart';
import '../widgets/navbar.dart';  

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 183, 66, 91),
              padding: const EdgeInsets.all(80),
              child: const Column(
                children: [
                   CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img2.jpg'),
                  ),
                   SizedBox(height: 10),
                   Text(
                    'Jhon Abraham',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    '@jhonabraham',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                   SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 183, 66, 91), // Maintain red background
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       ProfileInfoRow(
                        label: 'First Name',
                        value: 'Jhon',
                      ),
                       ProfileInfoRow(
                        label: 'Last Name',
                        value: 'Abraham',
                      ),
                       ProfileInfoRow(
                        label: 'Username',
                        value: 'Bomber',
                      ),
                       ProfileInfoRow(
                        label: 'Email Address',
                        value: 'jhonabraham20@gmail.com',
                      ),
                       ProfileInfoRow(
                        label: 'Bio',
                        value: 'Hey there! I\'m Alex, a 29-year-old musician who loves exploring new places and diving into a good book. When I\'m not strumming my guitar, you can find me hiking up a mountain or planning my next adventure. Looking for someone who enjoys great conversations, has a sense of humor, and is up for spontaneous road trips. Let\'s create some amazing memories together!',
                      ),
                       SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

