import 'dart:io';
import 'package:chat_app/services/permission_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final PermissionService _permissionService=Get.put(PermissionService());
  final ImagePicker _picker = ImagePicker();
  
  Future<File?> pickImageFromGallery() async {
    try{
      bool isGranted=await _permissionService.checkPermission(Permission.photos);
      if(isGranted){
        return await loadFromGallery();
      }else{
        bool permissionGranted = await _permissionService.requestPermission(Permission.photos);
        if (permissionGranted) {
          return await loadFromGallery();
        } else {
          _showPermissionDeniedMessage("photos");
          return null;
        }
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<File?> loadFromGallery()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
  
  Future<File?> pickImageFromCamera() async {
    try{
      bool isGranted=await _permissionService.checkPermission(Permission.camera);
      if(isGranted){
        return await loadFromCamera();
      }else{
        bool permissionGranted=await _permissionService.requestPermission(Permission.camera);
        if(permissionGranted){
          return await loadFromCamera();
        }else{
          _showPermissionDeniedMessage("camera");
          return null;
        }
      }
    }catch(e){
      throw Exception(e);
    }

  }

  Future<File?> loadFromCamera()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _showPermissionDeniedMessage(String permission) {
    Get.snackbar('Permission Denied', 'Please grant permission to access $permission');
  }
}
