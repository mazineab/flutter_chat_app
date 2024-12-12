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
      Message message = _buildMessage(senderUid,messageBody);
      Conversation conversation = _buildConversation(senderUid,receiverUid);

      await collectionReference.add(conversation.toJson()).then((DocumentReference doc) async {
        CollectionReference messagesCollection=collectionReference.doc(doc.id).collection('messages');
        await _updateDocumentWithUid(collectionReference, doc.id);
        messagesCollection.add(message.toJson()).then((msgDoc) async {
        await _updateDocumentWithUid(messagesCollection, msgDoc.id);
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Message _buildMessage(String senderUid, String content) {
    return Message(
      uid: '',
      senderId: senderUid,
      messageContent: content,
      isRead: false,
      createAt: DateTime.now(),
    );
  }

  Conversation _buildConversation(String senderUid, String receiverUid) {
    return Conversation(
      senderUid: senderUid,
      receiverUid: receiverUid,
      messages: [],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      isRead: false,
    );
  }

  Future<void> _updateDocumentWithUid(
      CollectionReference collection, String documentId) async {
    await collection.doc(documentId).update({'uid': documentId});
  }
}
