import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class ChatSErvice extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send message to chat room
  Future<void> sendMessage(
      int matchId, int senderId, int receiverId, String message) async {
    final Timestamp timestamp = Timestamp.now();

    // Create message
    Message newMessage = Message(
      receiverId: receiverId,
      senderId: senderId,
      timestamp: timestamp,
      message: message,
    );

    // Add message to chatroom collection
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(matchId.toString())
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(int matchId, int currentUserId) {
    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(matchId.toString())
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
