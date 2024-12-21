import 'package:chat_app/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? uid;
  String? senderDocId;
  String? receiverDocId;
  bool? isRead;                 
  Timestamp? createdAt;
  Timestamp? lastMessageAt;
  List<String>? participants;
  List<Message>? messages;

  Conversation({
    this.uid,
    this.senderDocId,
    this.receiverDocId,
    this.isRead,
    this.createdAt,
    this.lastMessageAt,
    this.messages,
    this.participants
  });

  Conversation.empty()
      : uid = '',
        senderDocId = '',
        receiverDocId = '',
        isRead = false,
        createdAt = Timestamp.fromDate(DateTime.now()),
        lastMessageAt = Timestamp.now(),
        participants = [],
        messages = [];

  factory Conversation.fromJson(Map<String, dynamic> data) {
    return Conversation(
        uid: data['uid'],
        senderDocId: data['senderDocId'],
        receiverDocId: data['receiverDocId'],
        isRead: data['isRead'],
        createdAt: data['createAt'] != null ? data['createAt'] as Timestamp : null,
        lastMessageAt:data['lastMessageAt'] != null ? data['lastMessageAt'] as Timestamp : null,
        participants: (data["participants"] as List<dynamic>?)?.cast<String>(),
        messages: data['messages'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "senderDocId": senderDocId,
      "receiverDocId": receiverDocId,
      "isRead": isRead,
      "createdAt": createdAt,
      "participants":participants,
      "lastMessageAt": lastMessageAt,
    };
  }
}
