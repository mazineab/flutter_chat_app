import 'package:chat_app/data/models/message.dart';

class Conversation {
  String? uid;
  String? senderDocId;
  String? receiverDocId;
  bool? isRead;                 
  DateTime? createdAt;          
  DateTime? lastMessageAt;
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

  factory Conversation.fromJson(Map<String, dynamic> data) {
    return Conversation(
        uid: data['uid'],
        senderDocId: data['senderDocId'],
        receiverDocId: data['receiverDocId'],
        isRead: data['isRead'],
        createdAt: DateTime.parse(data['createdAt']),
        lastMessageAt: DateTime.parse(data['lastMessageAt']),
        participants: (data["participants"] as List<dynamic>?)?.cast<String>(),
        messages: data['messages'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "senderDocId": senderDocId,
      "receiverDocId": receiverDocId,
      "isRead": isRead,
      "createdAt": createdAt?.toIso8601String(),
      "participants":participants,
      "lastMessageAt": lastMessageAt?.toIso8601String(),
    };
  }
}
