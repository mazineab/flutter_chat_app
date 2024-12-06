import 'package:chat_app/data/models/enums/sexe.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  AuthRepositories authRepositories=Get.put(AuthRepositories());
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();

  Future<void> createAccount() async {
    try {
      bool isCreated = await authRepositories.registerUser(
        User(
          uid: '',
          name: firstName.text,
          lastName: lastName.text,
          email: email.text,
          password: password.text,
          sexe: Sexe.male,
        ),
      );
      if (isCreated) {
        SnackBars.showSuccess("Account created successfully");
      } else {
        SnackBars.showError("Account not created");
      }
    } catch (e) {
      SnackBars.showError("Something went wrong");
    }
  }

  Future<void> login() async {
    try {
      bool isLoggedIn = await authRepositories.login(email.text, password.text);
      if (isLoggedIn) {
        SnackBars.showSuccess("Login successful");
      } else {
        SnackBars.showError("Failed to login");
      }
    } catch (e) {
      SnackBars.showError("Something went wrong");
    }
  }


}