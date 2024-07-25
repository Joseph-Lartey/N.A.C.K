import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/other_user.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../services/chat_service.dart';
import 'callPage.dart';

class ChatScreen extends StatefulWidget {
  final OtherUser otherUser;
  final int matchId;

  const ChatScreen({
    Key? key,
    required this.otherUser,
    required this.matchId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final String baseProfileDir =
      'http://16.171.150.101/N.A.C.K/backend/public/profile_images/';
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
          // Add the audio message to the list
          _sendAudioMessage();
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

  void _sendAudioMessage() {
    if (_recordedFilePath != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final chatService = Provider.of<ChatService>(context, listen: false);

      chatService.sendMessage(
        widget.matchId,
        authProvider.user?.userId ?? 0,
        widget.otherUser.userId,
        _recordedFilePath!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  '$baseProfileDir${widget.otherUser.profileImage}'),
            ),
            const SizedBox(width: 10),
            Text(
              '${widget.otherUser.firstName} ${widget.otherUser.lastName}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallPage(
                    callId: widget.matchId.toString(),
                    user: authProvider.user!,
                  ),
                ),
              );
            },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Message List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatService.getMessages(
                      widget.matchId, authProvider.user?.userId ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(
                          child:
                              Text('Something went wrong: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No messages found.'));
                    }
                    final messages = snapshot.data!.docs
                        .map((doc) =>
                            Message.fromMap(doc.data() as Map<String, dynamic>))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSentByMe =
                            message.senderId == authProvider.user?.userId;
                        return Row(
                          mainAxisAlignment: isSentByMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isSentByMe)
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '$baseProfileDir${widget.otherUser.profileImage}'),
                              ),
                            if (!isSentByMe) const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isSentByMe
                                      ? Color(0xFFB7425B).withOpacity(0.9)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(10),
                                    topLeft: isSentByMe
                                        ? const Radius.circular(10)
                                        : Radius.zero,
                                    topRight: isSentByMe
                                        ? Radius.zero
                                        : const Radius.circular(10),
                                  ),
                                ),
                                child: message.message.endsWith(
                                        '.aac') // Check if the message is an audio file
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.play_arrow),
                                            onPressed: () =>
                                                _playAudio(message.message),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Audio Message'),
                                        ],
                                      )
                                    : Text(
                                        message.message,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: isSentByMe
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                              ),
                            ),
                            if (isSentByMe) const SizedBox(width: 8),
                            if (isSentByMe)
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '$baseProfileDir${authProvider.user?.profileImage}'),
                              ),
                          ],
                        );
                      },
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
                          _sendMessage(
                              chatService, authProvider.user?.userId ?? 0);
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
                      onPressed: () => _sendMessage(
                          chatService, authProvider.user?.userId ?? 0),
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

  void _sendMessage(ChatService chatService, int senderId) {
    if (_controller.text.trim().isNotEmpty) {
      chatService.sendMessage(
        widget.matchId,
        senderId,
        widget.otherUser.userId,
        _controller.text.trim(),
      );
      _controller.clear();
    }
  }
}
