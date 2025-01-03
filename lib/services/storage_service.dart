import 'dart:io';

import 'package:chat_app/data/repositories/global_repositorie.dart';
import 'package:chat_app/data/repositories/users_repositorie.dart';
import 'package:chat_app/services/permission_service.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService extends GetxService {
  late FirebaseStorage _firebaseStorage;
  final GlobalRepositories globalRepositories=Get.put(GlobalRepositories());
  PermissionService permissionService=PermissionService();

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

  Future<void> saveImageToLocal(String imageUrl) async {
    try {
      // Check for storage permission
      bool isGranted = await Permission.storage.isGranted;
      if (!isGranted) {
        // Request storage permission
        isGranted = await Permission.storage.request().isGranted;
      }

      if (isGranted) {
        await downloadProcess(imageUrl);
      } else {
        CustomSnackBar.showError("Permission is required to save the image.");
      }
    } catch (e) {
      CustomSnackBar.showError("Failed to download this image.");
    }
  }

  Future<void> downloadProcess(String imageUrl) async {
    try {
      final response = await globalRepositories.downloadImage(imageUrl);
      final directory = await getExternalStorageDirectory();

      final filePath = "${directory?.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      CustomSnackBar.showSuccess("Image saved successfully at: $filePath");
      print("Image saved successfully at: $filePath");
    } catch (e) {
      CustomSnackBar.showError("Error while saving the image.");
      print("Error during file saving: $e");
    }
  }
}
