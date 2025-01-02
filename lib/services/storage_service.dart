import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageService extends GetxService {
  late FirebaseStorage _firebaseStorage;

  @override
  void onInit() {
    super.onInit();
    _firebaseStorage = FirebaseStorage.instanceFor(bucket: dotenv.env['bucket']);
  }

  Future<String> uploadImage(String path, File image) async {
    try {
      final ref = _firebaseStorage.ref(path);
      final uploadTask = await ref.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image");
    }
  }

  Future<String> uploadProfileImage(String userUid, File image) async {
    try {
      return await uploadImage("$userUid/profilePic", image);
    } catch (e) {
      print("Error uploading profile image for user $userUid: $e");
      throw Exception("Failed to upload profile image");
    }
  }

  Future<String> uploadImageInConversation(String conversationUid,File image)async{
    try{
      return await uploadImage("conversations/$conversationUid/${image.path}", image);
    }catch(e){
      print("Error: $e");
      throw Exception(e);
    }
  }
}
