import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final AuthController authController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:MediaQuery.sizeOf(context).width*0.75),
              CustomTextField(label: "First Name",controller: authController.firstName),const SizedBox(height: 20,),
              CustomTextField(label: "Last Name",controller: authController.lastName),const SizedBox(height: 20,),
              CustomTextField(label: "Email",controller: authController.email),const SizedBox(height: 20,),
              CustomTextField(label: "Password",controller: authController.password),const SizedBox(height: 20,),
              CustomButton(text: "Login",onTap: authController.createAccount)

            ],
          ),
        ),
      ),
    );
  }
}
