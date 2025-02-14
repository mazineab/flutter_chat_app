import 'dart:convert';
import 'dart:io';

import 'package:chat_app/data/models/enums/gender.dart';
import 'package:chat_app/data/models/user.dart' as auth_user;
import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:chat_app/services/image_picker_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/utils/local_storage/shared_pred_manager.dart';
import 'package:chat_app/utils/services/notification_service.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../widget/dialogs/dialog_loader.dart';

class AuthController extends GetxController{
  final ImagePickerService imagePicker=Get.put(ImagePickerService());
  StorageService storageService=Get.put(StorageService());
  AuthRepositories authRepositories=Get.put(AuthRepositories());
  NotificationService notificationService=Get.find<NotificationService>();
  final prefs = Get.find<SharedPredManager>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  /// controllers
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  /// keys
  final GlobalKey<FormFieldState<String>> emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> passwordKey = GlobalKey<FormFieldState<String>>();

  //vars
  RxInt currentIndex=0.obs;
  DateTime? _selectedDate;
  Rx<Gender> gender=Gender.male.obs;

  chooseGender(Gender newGender){
    gender.value=newGender;
    update();
  }

  Future<void> createAccount() async {
    try {
      DialogLoader.showLoadingDialog();
      String fcmToken=await notificationService.getFcmToken() ?? '';
      bool isCreated = await authRepositories.registerUser(
        auth_user.User(
          uid: '',
          docId: '',
          name: firstName.text,
          lastName: lastName.text,
          email: email.text,
          password: password.text,
          gender: gender.value,
          birthday:DateTime.parse(dateController.text),
          bio: bioController.text,
          phoneNumber: phoneNumController.text,
          fcmToken: fcmToken
        ),rxFile.value
      );
      if (isCreated) {
        CustomSnackBar.showSuccess("Account created successfully");
        clearData();
      } else {
        CustomSnackBar.showError("Account not created");
      }
    } catch (e) {
      CustomSnackBar.showError("Something went wrong");
    }
    finally{
      Get.close(1);
    }
  }

  Future<void> login() async {
    DialogLoader.showLoadingDialog();
    try {
      bool isLoggedIn = await authRepositories.login(email.text, password.text);
      if (isLoggedIn) {
        Get.close(1);
        await getDataOfCurrentUser();
        Get.offAllNamed(RoutesNames.home);
      } else {
        Get.close(1);
        CustomSnackBar.showError("Failed to login");
      }
    } catch (e) {
      Get.close(1);
      CustomSnackBar.showError("Something went wrong");
    }
  }

  Future<void> pickDate() async {
    DateTime now = DateTime.now();
    DateTime lastDate = DateTime(now.year - 16, 12, 31);
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _selectedDate ?? lastDate,
      firstDate: DateTime(1950),
      lastDate: lastDate,
      helpText: 'Select a Date',
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
        _selectedDate = pickedDate;
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
        update();
    }
  }

  changeSteep(bool next)async{
    if(next && currentIndex.value==1){
      await createAccount();
    }
    else{
      if(!next && currentIndex.value==1){
        currentIndex.value--;
      }else{
        if(next && currentIndex.value==0 && signUpKey.currentState!.validate()){
          currentIndex.value++;
        }
      }
    }
    update();
  }

  clearData(){
    currentIndex.value--;
    firstName.text='';
    lastName.text='';
    email.text='';
    password.text='';
    dateController.text='';
    bioController.text='';
    phoneNumController.text='';
    update();
  }


    getDataOfCurrentUser() async {
    try {
      final auth_user.User user = await authRepositories.getDataOfCurrentUser() ?? auth_user.User.empty();
      if (user.uid.isEmpty) {
        // await logout();
      }
      else {
        await authRepositories.updateFcmToken(await notificationService.getFcmToken()??'', user.docId);
        prefs.saveString("userData", jsonEncode(user.toJson()));
      }
    } catch (e) {
      CustomSnackBar.showError("Error:$e");
      // await logout();
    }
  }
  Rx<File?> rxFile = Rx<File?>(null);
  pickProfileImage()async{
    try{
      File? file=await imagePicker.loadFromGallery();
      rxFile.value=file;
    }catch(e){
      print(e);
      CustomSnackBar.showError("Failed to load the image. Please try again.");
    }finally{
      update();
    }
  }

}