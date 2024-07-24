import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final int receiverId;
  final int senderId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
    required this.message,
  });

  //Convert message details to map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp
    };
  }
}
