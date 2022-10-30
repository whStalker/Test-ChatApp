import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String userID;
  final String userName;
  final String message;
  final Timestamp timestamp;

  ChatModel({
    required this.userID,
    required this.userName,
    required this.message,
    required this.timestamp,
  });
}
