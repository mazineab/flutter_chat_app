import 'package:chat_app/modules/auth/screens/first_steep.dart';
import 'package:chat_app/modules/auth/screens/second_steep.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:chat_app/widget/dontHaveWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widget/custom_button.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Donthavewidget(text: "Are you have account ? ", spanText: "Login       ", voidCallback: (){
            Get.offNamed(RoutesNames.login);
          })
        ],
      ),
      resizeToAvoidBottomInset: true,
        body: GetBuilder<AuthController>(builder:(_) =>
          Form(
            key: authController.signUpKey,
            child: Stepper(
              onStepCancel:(){
                authController.changeSteep(false);
              } ,
              currentStep: authController.currentIndex.value,
                stepIconBuilder: (stepIndex, stepState) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(
                          "${stepIndex + 1}",
                          style: GoogleFonts.nunito(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                steps: [
              Step(
                  title: Text("Account Setup",
                      style: GoogleFonts.nunito(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  content: FirstSteep(authController: authController)),
              Step(
                  title: Text("Profile Customization",
                      style: GoogleFonts.nunito(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  content: SecondSteep(authController: authController)),
            ],
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    authController.currentIndex.value==1?TextButton(
                      onPressed: details.onStepCancel,
                      child: Text("Back",style:GoogleFonts.nunito(color: Colors.white),),
                    ):const SizedBox(),
                    Expanded(child: CustomButton(text: "Next",onTap:(){
                      authController.changeSteep(true);
                    })),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
