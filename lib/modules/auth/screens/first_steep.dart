import 'package:chat_app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/validators/auth_validation.dart';
import '../../../widget/custom_text_field.dart';

class FirstSteep extends StatelessWidget {
  final AuthController authController;
  const FirstSteep({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height:MediaQuery.sizeOf(context).width*0.10),
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
            "Create your account to chat with your friends.",
            style: GoogleFonts.nunito(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height:MediaQuery.sizeOf(context).width*0.15),
          CustomTextField(
            label: "First Name",controller: authController.firstName,
            textFormFieldKey: null, validation:(value){
            return AuthValidation.validateName(value,"First");
          } ,
            iconPrefix: Icons.person,
          ),
          const SizedBox(height: 20,),
          CustomTextField(
            label: "Last Name",controller: authController.lastName,
            textFormFieldKey: null,
            validation: (value ) { return AuthValidation.validateName(value,"Last"); },
            iconPrefix: Icons.person,
          ),
          const SizedBox(height: 20,),
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
          const SizedBox(height: 24,),

        ],
      ),
    );
  }
}
