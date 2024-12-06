import 'package:chat_app/modules/auth/controllers/auth_controller.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05),
        child: Column(
          children: [
            SizedBox(height:MediaQuery.sizeOf(context).width*0.75),
            CustomTextField(label: "Email",controller: authController.email),const SizedBox(height: 20,),
            CustomTextField(label: "Password",controller: authController.password),const SizedBox(height: 20,),
            CustomButton(text: "Login",onTap: authController.login,)

          ],
        ),
      ),
    );
  }

}
