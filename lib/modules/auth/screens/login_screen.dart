import 'package:chat_app/modules/auth/controllers/auth_controller.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:chat_app/utils/validators/auth_validation.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:chat_app/widget/dontHaveWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05),
        child: SingleChildScrollView(
          child: Form(
            key: authController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:MediaQuery.sizeOf(context).width*0.35),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to continue chatting with your friends.",
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height:MediaQuery.sizeOf(context).width*0.20),
                CustomTextField(
                    label: "Email",controller: authController.email,
                  textFormFieldKey:  authController.emailKey,
                  validation: (value){
                      return AuthValidation.validateEmail(value);
                  },
                    iconPrefix:FontAwesomeIcons.solidEnvelope
                ),
                const SizedBox(height: 20,),
                CustomTextField(
                  label: "Password",controller: authController.password,isPassword: true,
                  textFormFieldKey:  authController.passwordKey,
                  validation: (value){
                    return AuthValidation.validatePassword(value);
                  },
                  iconPrefix:FontAwesomeIcons.lock,
                ),
                forgetPassword(),
                const SizedBox(height: 20),
                CustomButton(text: "Login",onTap:(){
                  if(authController.formKey.currentState!.validate()){
                    authController.login();
                  }
                } ),
                const SizedBox(height: 24),
                buildOrDivider(),
                const SizedBox(height: 24),
                Donthavewidget(text: "Don't have an account ? ", spanText: 'Sign Up', voidCallback: (){
                  Get.offNamed(RoutesNames.signup);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildOrDivider(){
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }
  Widget forgetPassword(){
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.nunito(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

}
