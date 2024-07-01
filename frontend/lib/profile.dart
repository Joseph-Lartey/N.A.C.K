import 'package:flutter/material.dart';
import 'navbar.dart';  

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 66, 91), // Background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Pop the current screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 183, 66, 91),
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img2.jpg'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jhon Abraham',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '@jhonabraham',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                    //   IconButton(
                    //     icon: const Icon(Icons.message),
                    //     color: Colors.white,
                    //     onPressed: () {},
                    //   ),
                    //   IconButton(
                    //     icon: const Icon(Icons.videocam),
                    //     color: Colors.white,
                    //     onPressed: () {},
                    //   ),
                    //   IconButton(
                    //     icon: const Icon(Icons.phone),
                    //     color: Colors.white,
                    //     onPressed: () {},
                    //   ),
                    //   IconButton(
                    //     icon: const Icon(Icons.more_horiz),
                    //     color: Colors.white,
                    //     onPressed: () {},
                    //   ),
                    // ],
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
                      const ProfileInfoRow(
                        label: 'First Name',
                        value: 'Jhon',
                      ),
                      const ProfileInfoRow(
                        label: 'Last Name',
                        value: 'Abraham',
                      ),
                      const ProfileInfoRow(
                        label: 'Username',
                        value: 'Bomber',
                      ),
                      const ProfileInfoRow(
                        label: 'Email Address',
                        value: 'jhonabraham20@gmail.com',
                      ),
                      const ProfileInfoRow(
                        label: 'Bio',
                        value: 'Hey there! I\'m Alex, a 29-year-old musician who loves exploring new places and diving into a good book. When I\'m not strumming my guitar, you can find me hiking up a mountain or planning my next adventure. Looking for someone who enjoys great conversations, has a sense of humor, and is up for spontaneous road trips. Let\'s create some amazing memories together!',
                      ),
                      const SizedBox(height: 20),
                      // const Text(
                      //   'Media Shared',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // const SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       MediaThumbnail(assetPath: 'assets/img2.jpg'),
                      //       MediaThumbnail(assetPath: 'assets/img3.jpg'),
                      //       MediaThumbnail(assetPath: 'assets/img1.jpg'),
                      //       MediaThumbnail(assetPath: 'assets/img1.jpg'),
                      //       MediaThumbnail(assetPath: 'assets/img1.jpg'),
                      //       MediaThumbnail(assetPath: 'assets/img1.jpg'),
                      //       // Add more thumbnails if necessary
                      //     ],
                      //   ),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Handle view all media action
                      //   },
                      //   child: const Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Color.fromARGB(255, 183, 66, 91),
                      //     ),
                      //   ),
                      // ),
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

// class MediaThumbnail extends StatelessWidget {
//   final String assetPath;

//   const MediaThumbnail({required this.assetPath});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: Image.asset(
//           assetPath,
//           width: 80,
//           height: 80,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
