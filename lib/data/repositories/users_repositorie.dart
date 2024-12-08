import 'package:chat_app/data/models/user.dart' as usr;
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepositorie{
  FirebaseFirestore firebaseFireStore=FirebaseFirestore.instance;

  Future<List<usr.User>> fetchUsers()async{
    try{
      CollectionReference collectionReference=firebaseFireStore.collection('users');
      QuerySnapshot querySnapshot=await collectionReference.get();
      List<Map<String,dynamic>> users=querySnapshot.docs.map((e)=>e.data() as Map<String,dynamic>).toList();
      List<usr.User> listUsers=users.map((e)=>usr.User.fromJson(e)).toList();
      return listUsers;
    }catch(e){
      throw Exception(e);
    }
  }


}