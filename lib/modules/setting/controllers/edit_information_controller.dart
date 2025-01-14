import 'dart:convert';

import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/global_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/dialogs/dialog_loader.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/enums/gender.dart';
import '../../../utils/local_storage/shared_pred_manager.dart';

class EditInformationController extends GetxController {
  final GlobalRepositories globalRepositories = Get.find();
  final CurrentUserController currentUserController = Get.find();
  final prefs = Get.find<SharedPredManager>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final Rx<User> user = Rx(User.empty());
  final Rx<Gender> gender = Gender.male.obs;
  final RxString profilePicturePath = ''.obs;

  DateTime? _selectedDate;

  @override
  void onInit() {
    super.onInit();
    _initializeUserInformation();
  }

  Future<void> pickDate() async {
    DateTime now = DateTime.now();
    DateTime maxSelectableDate = DateTime(now.year - 16, 12, 31);

    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _selectedDate ?? maxSelectableDate,
      firstDate: DateTime(1950),
      lastDate: maxSelectableDate,
      helpText: 'Select a Date',
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      dateController.text = _formatDate(pickedDate);
      update();
    }
  }

  void chooseGender(Gender selectedGender) {
    gender.value = selectedGender;
    update();
  }

  void editInformation() async {
    final newUser = _buildUpdatedUser();

    if (newUser == user.value) {
      CustomSnackBar.showError("No changes detected.");
      return;
    }

    try {
      DialogLoader.showLoadingDialog();
      await globalRepositories.updateUserInformation(
        user.value.docId,
        newUser.toJson(),
      );
      prefs.saveString("userData", jsonEncode(user.toJson()));
      currentUserController.authUser.value=newUser;
      CustomSnackBar.showSuccess("Information updated successfully.");
    } catch (error) {
      CustomSnackBar.showError("An error occurred: ${error.toString()}");
    } finally {
      Get.close(1); // Close dialog
    }
  }

  // Private Helper Methods

  void _initializeUserInformation() {
    final currentUser = currentUserController.authUser.value;
    user.value = currentUser;

    profilePicturePath.value = currentUser.profilePicture ?? '';
    firstNameController.text = currentUser.name;
    lastNameController.text = currentUser.lastName;
    emailController.text = currentUser.email;
    dateController.text = _formatDate(currentUser.birthday);
    phoneNumController.text = currentUser.phoneNumber ?? '';
    bioController.text = currentUser.bio ?? '';
  }

  User _buildUpdatedUser() {
    return User(
      uid: user.value.uid,
      docId: user.value.docId,
      name: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: user.value.password,
      gender: gender.value,
      isNotificationEnabled: user.value.isNotificationEnabled,
      fcmToken: user.value.fcmToken,
      phoneNumber: phoneNumController.text,
      profilePicture: profilePicturePath.value,
      bio: bioController.text,
      birthday: _selectedDate,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.toLocal()}".split(' ')[0];
  }
}
