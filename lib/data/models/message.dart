import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  MessageType? messageType;
  String? uid;
  String? messageContent;
  String? senderId;
  bool? isRead;
  String? path;
  bool? isUpload;
  int? audioDuration;
  Timestamp? createdAt;

  Message({
    this.uid,
    this.messageContent,
    this.senderId,
    this.isRead,
    this.createdAt,
    this.path,
    this.isUpload,
    this.messageType,
    this.audioDuration
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      uid: json['uid'],
      messageContent: json['messageContent'],
      senderId: json['senderId'],
      isRead: json['read'],
      messageType: getType(json['messageType']),
      path:json['path'] ?? '',
      isUpload: json['isUpload'] ?? false,
      audioDuration:json['audioDuration'],
      createdAt: json['createdAt'] != null ? json['createdAt'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageContent': messageContent,
      'senderId': senderId,
      'read': isRead,
      'messageType':messageType?.toValue,
      'path':path,
      'isUpload':isUpload,
      'audioDuration':audioDuration,
      'createdAt': createdAt,
    };
  }


  @override
  String toString() {
    return 'Message{uid: $uid, messageContent: $messageContent, senderId: $senderId, isRead: $isRead, createAt: $createdAt}';
  }
}
