import 'package:chat_app/main.dart';
import 'package:chat_app/modules/auth/screens/first_steep.dart';
import 'package:chat_app/modules/setting/controllers/edit_information_controller.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_profile.dart';
import 'package:chat_app/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../data/models/enums/gender.dart';
import '../../../utils/validators/auth_validation.dart';
import '../../../widget/gender_card.dart';

class EditInformation extends StatelessWidget {
  const EditInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Your Information"),
        backgroundColor: AppColors.bgColors,
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<EditInformationController>(
        init: EditInformationController(),
        builder: (controller)=>
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                30.verticalSpace,
                CustomProfile(path:controller.profilePicturePath.value,picker: true),
                15.verticalSpace,
                CustomTextField(
                  label: "First Name",controller: controller.firstNameController,
                  textFormFieldKey: null, validation:(value){
                  return AuthValidation.validateName(value,"First");
                } ,
                  iconPrefix: Icons.person,
                ),
                15.verticalSpace,
                CustomTextField(
                  label: "Last Name",controller: controller.lastNameController,
                  textFormFieldKey: null,
                  validation: (value ) { return AuthValidation.validateName(value,"Last"); },
                  iconPrefix: Icons.person,
                ),
                15.verticalSpace,
                CustomTextField(
                    label: "Email",controller: controller.emailController,
                    textFormFieldKey:  null,
                    validation: (value){
                      return AuthValidation.validateEmail(value);
                    },
                    iconPrefix:FontAwesomeIcons.solidEnvelope
                ),
                15.verticalSpace,
                CustomTextField(
                  label: "Birthday",controller: controller.dateController,
                  textFormFieldKey:  null,
                  iconPrefix:FontAwesomeIcons.calendarDay,
                  onTap: controller.pickDate,
                  readOnly: true,
                ),
                15.verticalSpace,
                Obx(()=>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GenderCard(
                              groupValue: controller.gender.value,
                              onChanged: (value){
                                controller.chooseGender(Gender.male);
                              },
                              value: Gender.male
                          ),
                        ),const SizedBox(width: 5),
                        Expanded(
                          child: GenderCard(
                              groupValue: controller.gender.value,
                              onChanged: (value){
                                controller.chooseGender(Gender.female);
                              },
                              value: Gender.female
                          ),
                        ),

                      ],
                    ),
                ),
                15.verticalSpace,
                CustomTextField(
                  label: "Phone Number",controller: controller.phoneNumController,
                  textFormFieldKey: null,
                  iconPrefix:FontAwesomeIcons.phone,
                ),
                15.verticalSpace,
                CustomTextField(
                  label: "Bio",controller: controller.bioController,
                  textFormFieldKey: null,
                  iconPrefix: Icons.description,
                  maxLines: 5,
                ),
                15.verticalSpace,
                CustomButton(text: "Save Changes", onTap:controller.editInformation,horizontalMargin: 2,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
