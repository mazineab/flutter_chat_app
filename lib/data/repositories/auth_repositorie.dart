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


  Future<auth_user.User?> getDataOfCurrentUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        QuerySnapshot userDataSnapshot = await firebaseFireStore
            .collection('users')
            .where("id", isEqualTo: user.uid)
            .get();
        if (userDataSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userData =
          userDataSnapshot.docs.first.data() as Map<String, dynamic>;
          auth_user.User me=auth_user.User.fromJson(userData);
          return me;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}