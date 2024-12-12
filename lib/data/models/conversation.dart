import 'package:chat_app/data/models/message.dart';

class Conversation {
  String? uid;
  String? senderUid;
  String? receiverUid;
  bool? isRead;                 
  DateTime? createdAt;          
  DateTime? lastMessageAt;      
  List<Message>? messages; 

  Conversation({
    this.uid,
    this.senderUid,
    this.receiverUid,
    this.isRead,
    this.createdAt,
    this.lastMessageAt,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> data) {
    return Conversation(
        uid: data['uid'],
        senderUid: data['senderUid'],
        receiverUid: data['receiverUid'],
        isRead: data['isRead'],
        createdAt: data['createdAt'],
        lastMessageAt: data['lastMessageAt'],
        messages: data['messages'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "senderUid": senderUid,
      "receiverUid": receiverUid,
      "isRead": isRead,
      "createdAt": createdAt?.toIso8601String(),
      "lastMessageAt": lastMessageAt?.toIso8601String(),
      "messages": messages,
    };
  }
}
