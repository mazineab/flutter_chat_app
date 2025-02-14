import 'package:chat_app/data/models/enums/gender.dart';
import 'package:chat_app/widget/custom_profile.dart';
import 'package:chat_app/widget/gender_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../widget/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class SecondSteep extends StatelessWidget {
  final AuthController authController;
  const SecondSteep({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: ()=>authController.pickProfileImage(),
              child: CustomProfile(path: authController.rxFile.value?.path ?? '',)
          ),
          const SizedBox(height: 20,),
          CustomTextField(
            label: "Birthday",controller: authController.dateController,
            textFormFieldKey:  null,
            iconPrefix:FontAwesomeIcons.calendarDay,
            onTap: authController.pickDate,
            readOnly: true,
          ),
          const SizedBox(height: 20,),
           Obx(()=>
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GenderCard(
                      groupValue: authController.gender.value,
                      onChanged: (value){
                        authController.chooseGender(Gender.male);
                      },
                      value: Gender.male
                  ),
                ),const SizedBox(width: 5),
                Expanded(
                  child: GenderCard(
                      groupValue: authController.gender.value,
                      onChanged: (value){
                        authController.chooseGender(Gender.female);
                      },
                      value: Gender.female
                  ),
                ),

              ],
                       ),
           ),
          const SizedBox(height: 20,),
          CustomTextField(
            label: "Phone Number",controller: authController.phoneNumController,
            textFormFieldKey: null,
            // validation:(value){
            //   return AuthValidation.validateName(value);
            // },
            iconPrefix:FontAwesomeIcons.phone,
          ),
          const SizedBox(height: 20,),
          CustomTextField(
            label: "Bio",controller: authController.bioController,
            textFormFieldKey: null,
            // validation: (value ) { return AuthValidation.validateName(value); },
            iconPrefix: Icons.description,
            maxLines: 5,
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
