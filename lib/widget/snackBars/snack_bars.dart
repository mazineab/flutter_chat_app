import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
class SnackBars{
  static  showSuccess(String content){
    return toastification.show(
      context: Get.context,
      type:ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(content),
      // .... Other parameters
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  }

  static  showError(String content){
    return toastification.show(
      context: Get.context,
      type:ToastificationType.error,
      style: ToastificationStyle.minimal,
      title: Text(content),
      // .... Other parameters
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  }
}