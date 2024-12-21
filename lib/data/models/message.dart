import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? uid;
  String? messageContent;
  String? senderId;
  bool? isRead;
  Timestamp? createdAt;

  Message({
    this.uid,
    this.messageContent,
    this.senderId,
    this.isRead,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      uid: json['uid'],
      messageContent: json['messageContent'],
      senderId: json['senderId'],
      isRead: json['read'],
      createdAt: json['createdAt'] != null ? json['createdAt'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageContent': messageContent,
      'senderId': senderId,
      'read': isRead,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Message{uid: $uid, messageContent: $messageContent, senderId: $senderId, isRead: $isRead, createAt: $createdAt}';
  }
}
