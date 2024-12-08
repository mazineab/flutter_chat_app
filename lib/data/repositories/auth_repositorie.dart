import 'package:chat_app/data/models/authentication.dart';
import 'package:chat_app/data/models/user.dart' as auth_user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositories implements Authentication{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore=FirebaseFirestore.instance;

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
  Future<bool> registerUser(auth_user.User user)async {
    try{
      UserCredential userCredential=await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
      );
      if(userCredential.user!=null){
        DocumentReference documentReference=await firebaseFireStore.collection('users').add(user.toJson());
        user.uid=documentReference.id;
        await documentReference.update(user.toJson());
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }

}