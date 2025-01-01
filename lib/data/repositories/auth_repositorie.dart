import 'dart:io';

import 'package:chat_app/data/models/authentication.dart';
import 'package:chat_app/data/models/user.dart' as auth_user;
import 'package:chat_app/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepositories implements Authentication{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore=FirebaseFirestore.instance;
  final StorageService _storageService=Get.put(StorageService());

  @override
  Future<bool> login(String email, String password)async {
    try{
      UserCredential userCredential=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!=null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> logout() async{
    try{
      await firebaseAuth.signOut();
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<bool> registerUser(auth_user.User user,File? image)async {
    try{
      UserCredential userCredential=await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
      );
      if(userCredential.user!=null){
        user.uid=userCredential.user!.uid;
        DocumentReference documentReference=await firebaseFireStore.collection('users').add(user.toJson());
        user.docId=documentReference.id;
        if(image!=null){
          String path=await _storageService.uploadProfileImage(documentReference.id, image);
          user.profilePicture=path;
        }
        await documentReference.update(user.toJson());
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }


  Future<auth_user.User?> getDataOfCurrentUser() async {
    try {
      final User? currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        return null;
      }
      QuerySnapshot userDataSnapshot = await firebaseFireStore
          .collection('users')
          .where("uid", isEqualTo: currentUser.uid)
          .get();
      if (userDataSnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> userData =
        userDataSnapshot.docs.first.data() as Map<String, dynamic>;

        return auth_user.User.fromJson(userData);
      }

      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateFcmToken(String fcmToken,String userUid)async=>
    await firebaseFireStore.collection("users").doc(userUid).update({"fcmToken":fcmToken});


}