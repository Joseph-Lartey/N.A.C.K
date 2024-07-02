import 'package:flutter/material.dart';
import 'messages.dart';

class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen(this.message, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.message.name,
          style: TextStyle(fontSize: 22), // Increase font size of the title
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Action for phone call
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Action for video call
            },
          ),
        ],
        toolbarHeight: 70, // Increase the height of the AppBar
      ),
      body: Stack(
        children: [
          // Wallpaper
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/wallpaper.jpg'), // Replace with your wallpaper image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Message List
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(_messages[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Message Input
              Container(
                color: Colors.white, // White background for the bottom bar
                padding: const EdgeInsets.all(12.0), // Increase padding
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        // Action for camera
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {
                        // Action for attachments
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: (text) {
                          _sendMessage();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        // Action for microphone
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () {
                        // Action for gallery
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }
}
