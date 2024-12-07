import 'package:chat_app/data/models/enums/sexe.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/dialogs/dialog_loader.dart';

class AuthController extends GetxController{
  AuthRepositories authRepositories=Get.put(AuthRepositories());

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
  Rx<Sexe> gender=Sexe.male.obs;

  chooseSexe(Sexe sexe){
    gender.value=sexe;
    update();
  }

  Future<void> createAccount() async {
    try {
      DialogLoader.showLoadingDialog();
      bool isCreated = await authRepositories.registerUser(
        User(
          uid: '',
          name: firstName.text,
          lastName: lastName.text,
          email: email.text,
          password: password.text,
          sexe: gender.value,
          birthday:DateTime.parse(dateController.text),
          bio: bioController.text,
          phoneNumber: phoneNumController.text,
        ),
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
    try {
      bool isLoggedIn = await authRepositories.login(email.text, password.text);
      if (isLoggedIn) {
        CustomSnackBar.showSuccess("Login successful");
      } else {
        CustomSnackBar.showError("Failed to login");
      }
    } catch (e) {
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
        if(next && currentIndex.value==0 && formKey.currentState!.validate()){
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

}