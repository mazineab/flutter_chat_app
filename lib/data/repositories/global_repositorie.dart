import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GlobalRepositories {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<http.Response> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            "Failed to download image status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during image download: $e");
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateNotificationStatus(String userDocId, bool status) async {
    try {
      CollectionReference collectionReference =
          firebaseFirestore.collection('users');
      await collectionReference
          .doc(userDocId)
          .update({'isNotificationEnabled': status});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUserInformation(
      String userDocId, Map<String, dynamic> data) async {
    try {
      CollectionReference collectionReference =
          firebaseFirestore.collection('users');
      await collectionReference.doc(userDocId).update(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Message>> fetchPhotos(String userUid) async {
    try {
      List<Message> listPhotos = [];
      CollectionReference collectionReference =
      firebaseFirestore.collection('conversations');
      QuerySnapshot querySnapshot = await collectionReference
          .where("participants", arrayContains: userUid)
          .get();

      // Use a for loop with await to handle asynchronous operations properly
      for (var doc in querySnapshot.docs) {
        List<Message> listMessage = await _fetchMessageOfConversation(collectionReference, doc);
        listPhotos.addAll(listMessage);
      }

      return listPhotos;
    } catch (e) {
      throw Exception("Error fetching photos: $e");
    }
  }

  Future<List<Message>> _fetchMessageOfConversation(
      CollectionReference collection, QueryDocumentSnapshot doc) async {
    try {
      QuerySnapshot querySnapshot = await collection
          .doc(doc.id)
          .collection('messages')
          .where("messageType", isEqualTo: "Image")
          .get();
      return querySnapshot.docs
          .map((e) => Message.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching messages from conversation: $e");
    }
  }

}
