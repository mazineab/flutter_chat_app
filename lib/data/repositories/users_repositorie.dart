import 'package:chat_app/data/models/user.dart' as usr;
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersRepositorie{
  FirebaseFirestore firebaseFireStore=FirebaseFirestore.instance;
  CurrentUserController currentUserController=Get.find();

  Future<List<usr.User>> fetchUsers()async{
    try{
      CollectionReference collectionReference=firebaseFireStore.collection('users');
      QuerySnapshot querySnapshot=await collectionReference.where('uid',isNotEqualTo:currentUserController.authUser.value.uid).get();
      List<Map<String,dynamic>> users=querySnapshot.docs.map((e)=>e.data() as Map<String,dynamic>).toList();
      List<usr.User> listUsers=users.map((e)=>usr.User.fromJson(e)).toList();
      return listUsers;
    }catch(e){
      throw Exception(e);
    }
  }


}