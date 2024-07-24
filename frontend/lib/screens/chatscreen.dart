import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'messages.dart'; // Ensure this file contains the Message class definition

class ChatScreen extends StatefulWidget {
  final  message;

  const ChatScreen(this.message, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi there!', 'isSentByMe': false},
    {'text': 'Hello!', 'isSentByMe': true},
  ];
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAudio();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0], // Use the first available camera
        ResolutionPreset.high,
      );

      await _cameraController?.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  Future<void> _initializeAudio() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    // await _recorder?.openAudioSession();
    // await _player?.openAudioSession();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    // _recorder?.closeAudioSession();
    // _player?.closeAudioSession();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_recorder?.isRecording == false) {
      final Directory tempDir = await getTemporaryDirectory();
      _recordedFilePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder?.startRecorder(toFile: _recordedFilePath);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_recorder?.isRecording == true) {
      await _recorder?.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      // Add the recorded audio file to messages
      if (_recordedFilePath != null) {
        setState(() {
          _messages.add({
            'text': _recordedFilePath!,
            'isSentByMe': true,
            'isAudio': true, // Indicate this message is an audio file
          });
        });
      }
    }
  }

  Future<void> _playAudio(String filePath) async {
    if (_player?.isPlaying == false) {
      await _player?.startPlayer(fromURI: filePath, codec: Codec.aacADTS);
    } else {
      await _player?.stopPlayer();
    }
  }

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
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              // Action for phone call
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
                    return Row(
                      mainAxisAlignment: message['isSentByMe']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!message['isSentByMe'])
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(widget.message
                                .avatar), // Avatar image for received messages
                          ),
                        if (!message['isSentByMe'])
                          const SizedBox(
                              width: 8), // Space between avatar and message
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: message['isSentByMe']
                                  ? Color(0xFFB7425B).withOpacity(0.9)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(10),
                                bottomRight: const Radius.circular(10),
                                topLeft: message['isSentByMe']
                                    ? const Radius.circular(10)
                                    : Radius
                                        .zero, // Not rounded for received messages
                                topRight: message['isSentByMe']
                                    ? Radius
                                        .zero // Not rounded for sent messages
                                    : const Radius.circular(10),
                              ),
                            ),
                            child: message['isAudio'] == true
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () =>
                                            _playAudio(message['text']),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Audio Message'),
                                    ],
                                  )
                                : message['isImage'] == true
                                    ? Image.file(File(
                                        message['text'])) // Display the image
                                    : Text(
                                        message['text'],
                                        style: TextStyle(
                                          fontSize: 18, // Increased font size
                                          color: message['isSentByMe']
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                          ),
                        ),
                        if (message['isSentByMe'])
                          const SizedBox(
                              width: 8), // Space between message and avatar
                        if (message['isSentByMe'])
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                                'assets/your_avatar.png'), // Replace with sender's avatar image
                          ),
                      ],
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
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () async {
                        if (_isCameraInitialized) {
                          // await _takePicture();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file_outlined),
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
                      icon: Icon(
                          _isRecording ? Icons.stop : Icons.mic_none_outlined),
                      onPressed:
                          _isRecording ? _stopRecording : _startRecording,
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
        _messages.add({
          'text': _controller.text.trim(),
          'isSentByMe': true,
          'isImage': false, // Indicate this message is not an image
          'isAudio': false, // Indicate this message is not an audio file
        });
        _controller.clear();
      });
    }
  }
}
