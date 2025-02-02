import 'dart:io';
import 'package:chat_app/data/repositories/global_repositorie.dart';
import 'package:path/path.dart';
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
      throw Exception("Error uploading image");
    }
  }

  Future<String> uploadProfileImage(String userUid, File image) async {
    try {
      return await uploadImage("profiles/$userUid/profilePic", image);
    } catch (e) {
      throw Exception("Failed to upload profile image");
    }
  }

  Future<String> uploadImageInConversation(String conversationUid,File image)async{
    try{
      String imageName = basename(image.path);
      return await uploadImage("conversations/$conversationUid/$imageName", image);
    }catch(e){
      print("Error: $e");
      throw Exception(e);
    }
  }

  Future<String> uploadAudioInConversation(String conversationUid,File audio,String messageUid)async{
    try{
      return await uploadImage("conversations/$conversationUid/$messageUid", audio);
    }catch(e){
      print("Error: $e");
      throw Exception(e);
    }
  }

  Future<void> saveImageToLocal(String imageUrl) async {
    try {
      bool isGranted = await Permission.storage.isGranted;
      if (!isGranted) {
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
    } catch (e) {
      CustomSnackBar.showError("Error while saving the image.");
    }
  }
}
