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
        user.uid=userCredential.user!.uid;
        DocumentReference documentReference=await firebaseFireStore.collection('users').add(user.toJson());
        user.docId=documentReference.id;
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
      // Get the currently logged-in user
      final User? currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        return null; // No user logged in
      }

      // Fetch user data from Firestore
      print("Current User UID: ${currentUser.uid}");
      QuerySnapshot userDataSnapshot = await firebaseFireStore
          .collection('users')
          .where("uid", isEqualTo: currentUser.uid)
          .get();

      // Check if user data exists
      if (userDataSnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> userData =
        userDataSnapshot.docs.first.data() as Map<String, dynamic>;

        // Map the JSON to your User model
        return auth_user.User.fromJson(userData);
      }

      return null; // User data not found
    } catch (e) {
      print('Error fetching user data: $e'); // Log the error for debugging
      return null; // Return null to handle errors gracefully
    }
  }

  Future<void> updateFcmToken(String fcmToken,String userUid)async=>
    await firebaseFireStore.collection("users").doc(userUid).update({"fcmToken":fcmToken});


}