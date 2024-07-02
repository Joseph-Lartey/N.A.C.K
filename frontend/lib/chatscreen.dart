import 'package:flutter/material.dart';
import 'messages.dart'; // Ensure this file contains the Message class definition

class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen(this.message, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    // Example initial messages
    {'text': 'Hi there!', 'isSentByMe': false},
    {'text': 'Hello!', 'isSentByMe': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage(widget.message.avatar), // Avatar image
            ),
            const SizedBox(width: 10),
            Text(
              widget.message.name,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // Action for phone call
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Action for video call
            },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          // Wallpaper
          Container(
            decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message['isSentByMe']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: message['isSentByMe']
                              ? Colors.blueAccent.withOpacity(0.7)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: message['isSentByMe']
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Message Input
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        // Action for camera
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: (text) {
                          _sendMessage();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
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
        _messages.add({'text': _controller.text.trim(), 'isSentByMe': true});
        _controller.clear();
      });
    }
  }
}
