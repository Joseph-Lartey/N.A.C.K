import 'package:flutter/material.dart';
import 'navbar.dart';  // Assuming this is where CustomBottomAppBar() is defined

class ProfilePage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 183, 66, 91),
              padding: EdgeInsets.all(16),
              child: Column(
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
                    children: [
                      IconButton(
                        icon: Icon(Icons.message),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.videocam),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.phone),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Color.fromARGB(255, 183, 66, 91), // Maintain red background
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileInfoRow(
                        label: 'Display Name',
                        value: 'Jhon Abraham',
                      ),
                      ProfileInfoRow(
                        label: 'Email Address',
                        value: 'jhonabraham20@gmail.com',
                      ),
                      ProfileInfoRow(
                        label: 'Address',
                        value: '33 street west subidbazar, sylhet',
                      ),
                      ProfileInfoRow(
                        label: 'Phone Number',
                        value: '(320) 555-0104',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Media Shared',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MediaThumbnail(assetPath: 'assets/img2.jpg'),
                            MediaThumbnail(assetPath: 'assets/img3.jpg'),
                            MediaThumbnail(assetPath: 'assets/img1.jpg'),
                            MediaThumbnail(assetPath: 'assets/img1.jpg'),
                            MediaThumbnail(assetPath: 'assets/img1.jpg'),
                            MediaThumbnail(assetPath: 'assets/img1.jpg'),
                            // Add more thumbnails if necessary
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle view all media action
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: Color.fromARGB(255, 183, 66, 91),
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
      ),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class MediaThumbnail extends StatelessWidget {
  final String assetPath;

  MediaThumbnail({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          assetPath,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
