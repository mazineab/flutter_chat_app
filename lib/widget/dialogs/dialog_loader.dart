import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DialogLoader{
  static void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(backgroundColor:Colors.white)),
      barrierDismissible: true,
      name: "loaderDialog",
    );
  }
}