import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRepositories {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CurrentUserController currentUserController=Get.find();

  Future<void> createConversation(
      String senderUid, String receiverUid, String messageBody) async {
    try {
      CollectionReference collectionReference =
          _firebaseFirestore.collection("conversations");
      Message message = _buildMessage(senderUid,messageBody);
      Conversation conversation = _buildConversation(senderUid,receiverUid);
      if(await checkConversationExist(collectionReference)){
        Conversation conversation=await fetchExistingConversation(collectionReference);
        CollectionReference messagesCollection=collectionReference.doc(conversation.uid).collection('messages');
        messagesCollection.add(message.toJson()).then((msgDoc) async {
          await _updateDocumentWithUid(messagesCollection, msgDoc.id);
        });
      }else{
        await collectionReference.add(conversation.toJson()).then((DocumentReference doc) async {
          CollectionReference messagesCollection=collectionReference.doc(doc.id).collection('messages');
          await _updateDocumentWithUid(collectionReference, doc.id);
          messagesCollection.add(message.toJson()).then((msgDoc) async {
            await _updateDocumentWithUid(messagesCollection, msgDoc.id);
          });
        });
      }
      await fetchConversations();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> checkConversationExist(CollectionReference collectionReference)async{
    QuerySnapshot querySnapshot = await collectionReference
        .where("participants", arrayContains: currentUserController.authUser.value.docId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<Conversation> fetchExistingConversation(CollectionReference collectionReference)async{
    QuerySnapshot querySnapshot = await collectionReference
        .where("participants", arrayContains: currentUserController.authUser.value.docId)
        .get();
    return Conversation.fromJson(querySnapshot.docs.first.data() as Map<String,dynamic>);
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

  Conversation _buildConversation(String senderDocId, String receiverDocId) {
    return Conversation(
      senderDocId: senderDocId,
      receiverDocId: receiverDocId,
      // messages: [],
      participants: [senderDocId,receiverDocId],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      isRead: false,
    );
  }

  Future<void> _updateDocumentWithUid(
      CollectionReference collection, String documentId) async {
    await collection.doc(documentId).update({'uid': documentId});
  }


  Future<List<Conversation>> fetchConversations()async{
    try{
      CollectionReference collectionReference = _firebaseFirestore.collection("conversations");
      QuerySnapshot querySnapshot = await collectionReference
          .where("participants", arrayContains: currentUserController.authUser.value.docId)
          .get();
      List<Conversation> listConversations = await Future.wait(
        querySnapshot.docs.map((doc) async {
          List<Message> listMessage =
          await fetchMessageOfConversation(collectionReference, doc);
          Map<String, dynamic> conversationData = doc.data() as Map<String, dynamic>;
          conversationData['messages'] = listMessage;
          return Conversation.fromJson(conversationData);
        }).toList(),
      );
      return listConversations;
    }catch(e){
      throw Exception(e);
    }
  }
  
  Future<List<Message>> fetchMessageOfConversation(CollectionReference collection,QueryDocumentSnapshot doc)async{
    try{
    QuerySnapshot querySnapshot=await collection.doc(doc.id).collection('messages').get();
    return querySnapshot.docs.map((e)=>Message.fromJson(e.data() as Map<String,dynamic>)).toList();
    }catch(e){
      throw Exception(e);
    }
  }

  Future<String> getUserFullName(String docId)async{
    try{
      CollectionReference collectionReference=_firebaseFirestore.collection('users');
      QuerySnapshot querySnapshot=await collectionReference.where('docId',isEqualTo: docId).get();
      return querySnapshot.docs.first['name'] as String;
    }catch(e){
      throw Exception(e);
    }
  }
}
