import 'dart:async';

import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRepositories {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CurrentUserController currentUserController=Get.find();

  /// This function creates a conversation between two users.
  /// It checks if the conversation already exists to avoid duplication.
  Future<void> createConversation(
      String senderUid, String receiverUid, String messageBody,bool isSender) async {
    try {
      CollectionReference collectionReference =
          _firebaseFirestore.collection("conversations");
      Message message = _buildMessage(senderUid,messageBody);
      String senderFullName=await getUserFullName(senderUid);
      String senderProfilePicture=await getUserProfile(senderUid);
      String receiverFullName=await getUserFullName(receiverUid);
      String receiverProfilePicture=await getUserProfile(receiverUid);

      Conversation conversation = _buildConversation(
          senderDocId: senderUid,
          receiverDocId: receiverUid,
          senderFullName: senderFullName,
          receiverFullName: receiverFullName,
          lastMessageAt: message.createdAt!,
          lastMessage: message.messageContent!,
          unreadReceiverCount: isSender? 1 : 0,
          unreadSenderCount: isSender ? 0:1,
          senderProfilePicture: senderProfilePicture,
        receiverProfilePicture: receiverProfilePicture
      );
      if(await checkConversationExist(collectionReference,senderUid,receiverUid)){
        Conversation existConversation=await fetchExistingConversation(collectionReference,receiverUid);
        CollectionReference messagesCollection=collectionReference.doc(existConversation.uid).collection('messages');
        messagesCollection.add(message.toJson()).then((msgDoc) async {
          await updateConversation(existConversation.uid!,conversation,isSender);
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

  /// This function checks if a conversation exists or not.
  Future<bool> checkConversationExist(CollectionReference collectionReference,String senderUid,String receiverUid)async{
    QuerySnapshot querySnapshot = await collectionReference
        .where("participants", arrayContains: senderUid)
        .get();
    bool exists = querySnapshot.docs.any((doc) {
      List<dynamic> participants = doc["participants"];
      return participants.contains(receiverUid);
    });
    return exists;
  }
  /// This function fetches an existing conversation.
  Future<Conversation> fetchExistingConversation(CollectionReference collectionReference,String receiverUid)async{
    QuerySnapshot querySnapshot = await collectionReference
        .where("participants", arrayContains: currentUserController.authUser.value.docId)
        .get();
    DocumentSnapshot matchingDocument=querySnapshot.docs.firstWhere((doc) {
      List<dynamic> participants = doc["participants"];
      return participants.contains(receiverUid);
    });
    return Conversation.fromJson(matchingDocument.data() as Map<String,dynamic>);
  }

  /// This function is used to send a message.
  Future<String> sendMessage(Message message,String conversationUid,bool isSender)async {
    try{
      String messageUid='';
      Conversation conversation=Conversation(
        lastMessage:message.messageContent,
        lastMessageAt: message.createdAt
      );

      CollectionReference conversationsCollection= _firebaseFirestore.collection("conversations");
      CollectionReference messagesCollection = conversationsCollection.doc(conversationUid).collection("messages");
      DocumentReference msgDoc = await messagesCollection.add(message.toJson());
      messageUid = msgDoc.id;

      await updateConversation(conversationUid, conversation, isSender);
      await _updateDocumentWithUid(messagesCollection, msgDoc.id);

      return messageUid;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updateMessagePath(String conversationUid,String messageUid,String newPath)async{
    try{
      CollectionReference conversationsCollection= _firebaseFirestore.collection("conversations");
      CollectionReference messagesCollection = conversationsCollection.doc(conversationUid).collection("messages");
      DocumentReference documentReference=messagesCollection.doc(messageUid);
      await documentReference.update({"path":newPath,'isUpload':false});
    }catch(e){
      throw Exception(e);
    }
  }

  Message _buildMessage(String senderUid, String content) {
    return Message(
      uid: '',
      senderId: senderUid,
      messageContent: content,
      isRead: false,
      createdAt: Timestamp.fromDate(DateTime.now()),
    );
  }

  Conversation _buildConversation(
      {
        required String senderDocId,
      required String receiverDocId,
      required String senderFullName,
      required String receiverFullName,
        required Timestamp lastMessageAt,
        required int unreadSenderCount,
        required int unreadReceiverCount,
        required String lastMessage,
        required String senderProfilePicture,
        required String receiverProfilePicture,
      }) {
    return Conversation(
      senderDocId: senderDocId,
      senderFullName: senderFullName,
      receiverFullName: receiverFullName,
      receiverDocId: receiverDocId,
      participants: [senderDocId,receiverDocId],
      createdAt : Timestamp.fromDate(DateTime.now()),
      lastMessageAt : lastMessageAt,
      lastMessage:lastMessage ,
      unreadReceiverMessages: unreadReceiverCount,
      unreadSenderMessages: unreadSenderCount,
      senderProfilePicture: senderProfilePicture,
      receiverProfilePicture: receiverProfilePicture
    );
  }

  Future<void> updateConversation(String docId,Conversation conversation,bool isSender)async {
    DocumentSnapshot documentSnapshot=await _firebaseFirestore.collection('conversations').doc(docId).get();
    Conversation existConversation=Conversation.fromJson(documentSnapshot.data() as Map<String,dynamic>);
    int updatedUnreadMessages = isSender
        ? (existConversation.unreadReceiverMessages ?? 0) + 1
        : (existConversation.unreadSenderMessages ?? 0) + 1;
    _firebaseFirestore.collection("conversations").doc(docId).update(
        {
          "lastMessage": conversation.lastMessage,
          "lastMessageAt": conversation.lastMessageAt,
          isSender
              ? "unreadReceiverMessages"
              :"unreadSenderMessages" :updatedUnreadMessages
        });
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
          await _fetchMessageOfConversation(collectionReference, doc);
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

  StreamSubscription<QuerySnapshot> conversationStream({
    required Function(List<Conversation>) onData,
    required Function(Object) onError,
  }) {
    try {
      CollectionReference collectionReference =
      _firebaseFirestore.collection("conversations");

      return collectionReference
          .where("participants",
          arrayContains: currentUserController.authUser.value.docId)
          .snapshots()
          .listen(
            (querySnapshot) async {
          try {
            List<Conversation> listConversations = await Future.wait(
              querySnapshot.docs.map((doc) async {
                List<Message> listMessage =
                await _fetchMessageOfConversation(collectionReference, doc);
                Map<String, dynamic> conversationData =
                doc.data() as Map<String, dynamic>;
                conversationData['messages'] = listMessage;
                return Conversation.fromJson(conversationData);
              }).toList(),
            );
            onData(listConversations);
          } catch (e) {
            onError(e);
          }
        },
        onError: (error) {
          onError(error);
        },
      );
    } catch (e) {
      onError(e);
      throw Exception(e);
    }
  }


  Future<List<Message>> _fetchMessageOfConversation(CollectionReference collection,QueryDocumentSnapshot doc)async{
    try{
    QuerySnapshot querySnapshot=await collection.doc(doc.id).collection('messages').get();
    return querySnapshot.docs.map((e)=>Message.fromJson(e.data() as Map<String,dynamic>)).toList();
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<Message>> fetchMessageOfConversation(String conversationUid)async{
    try{
      CollectionReference collectionReference=_firebaseFirestore.collection("conversations");
      QuerySnapshot querySnapshot=await collectionReference.doc(conversationUid).collection('messages')
          .orderBy("createdAt",descending: true).get();
      return querySnapshot.docs.map((e)=>Message.fromJson(e.data() as Map<String,dynamic>)).toList();
    }catch(e){
      throw Exception(e);
    }
  }
  StreamSubscription<QuerySnapshot> messagesStream(String conversationUid,{required Function(List<Message>) onData,required Function(Object) onError}){
    try{
      CollectionReference collectionReference=_firebaseFirestore.collection("conversations");
      return collectionReference.doc(conversationUid).collection('messages').orderBy("createdAt",descending: true)
          .snapshots().listen((querySnapshot){
        List<Message> listMessages=querySnapshot.docs.map((e)=>Message.fromJson(e.data() as Map<String,dynamic>)).toList();
        onData(listMessages);
      });
    }catch(e){
      onError(e);
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

  Future<String> getUserProfile(String docId)async{
    try{
      CollectionReference collectionReference=_firebaseFirestore.collection('users');
      QuerySnapshot querySnapshot=await collectionReference.where('docId',isEqualTo: docId).get();
      return querySnapshot.docs.first['profilePicture'] ?? '';
    }catch(e){
      throw Exception(e);
    }

  }

  Future<void> markConversationAsRead(Conversation conversation,bool isSender)async{
    try{
      _firebaseFirestore.collection("conversations").doc(conversation.uid).update(
          isSender
              ?{"unreadSenderMessages":0}
              :{"unreadReceiverMessages":0}
      );
    }catch(e){
      throw Exception(e);
    }
  }
}
