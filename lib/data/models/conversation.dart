import 'package:chat_app/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? uid;
  String? senderDocId;
  String? receiverDocId;
  String? senderFullName;
  String? receiverFullName;
  Timestamp? createdAt;
  Timestamp? lastMessageAt;
  List<String>? participants;
  int? unreadSenderMessages;
  int? unreadReceiverMessages;
  String? lastMessage;
  String? senderProfilePicture;
  String? receiverProfilePicture;

  Conversation({
    this.uid,
    this.senderDocId,
    this.receiverDocId,
    this.senderFullName,
    this.receiverFullName,
    this.createdAt,
    this.lastMessageAt,
    this.participants,
    this.unreadSenderMessages,
    this.unreadReceiverMessages,
    this.lastMessage,
    this.senderProfilePicture,
    this.receiverProfilePicture

  });

  Conversation.empty()
      : uid = '',
        senderDocId = '',
        receiverDocId = '',
        createdAt = Timestamp.fromDate(DateTime.now()),
        lastMessageAt = Timestamp.now(),
        participants = [];

  factory Conversation.fromJson(Map<String, dynamic> data) {
    return Conversation(
        uid: data['uid'],
        senderDocId: data['senderDocId'],
        senderFullName: data['senderFullName'],
        receiverFullName: data['receiverFullName'],
        receiverDocId: data['receiverDocId'],
        createdAt: data['createdAt'] != null ? data['createdAt'] as Timestamp : null,
        lastMessageAt:data['lastMessageAt'] != null ? data['lastMessageAt'] as Timestamp : null,
        participants: (data["participants"] as List<dynamic>?)?.cast<String>(),
        unreadSenderMessages: data['unreadSenderMessages'],
        unreadReceiverMessages: data['unreadReceiverMessages'],
        lastMessage: data['lastMessage'],
        senderProfilePicture:data['senderProfilePicture'],
        receiverProfilePicture: data['receiverProfilePicture']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "senderDocId": senderDocId,
      "senderFullName":senderFullName,
      "receiverDocId": receiverDocId,
      "receiverFullName":receiverFullName,
      "createdAt": createdAt,
      "participants":participants,
      "lastMessage":lastMessage,
      "unreadSenderMessages":unreadSenderMessages,
      "unreadReceiverMessages":unreadReceiverMessages,
      "lastMessageAt": lastMessageAt,
      'senderProfilePicture':senderProfilePicture,
      'receiverProfilePicture':receiverProfilePicture
    };
  }
}
