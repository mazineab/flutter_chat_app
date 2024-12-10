import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepositorie {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createConverstion(
      String senderUid, String receiverUid, String messageBody) async {
    try {
      CollectionReference collectionReference =
          _firebaseFirestore.collection("conversations");
      Message message = Message(
          senderId: senderUid,
          messageContent: messageBody,
          isRead: false,
          createAt: DateTime.now());
      Conversation conversation = Conversation(
        senderUid: senderUid,
        receiverUid: receiverUid,
        messages: [message],
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
        isRead: false,
      );
      await collectionReference.add(conversation.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }
}
