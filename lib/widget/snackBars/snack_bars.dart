import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  // Success Snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      "Success", // Title of snackbar
      message, // Message of snackbar
      snackPosition: SnackPosition.TOP, // Snackbar position
      backgroundColor: Colors.green, // Green background for success
      colorText: Colors.white, // Text color
      icon: const Icon(Icons.check_circle, color: Colors.white), // Success Icon
      duration: const Duration(seconds: 3), // Duration for snackbar visibility
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Error Snackbar
  static void showError(String message) {
    Get.snackbar(
      "Error", // Title of snackbar
      message, // Message of snackbar
      snackPosition: SnackPosition.TOP, // Snackbar position
      backgroundColor: Colors.red, // Red background for error
      colorText: Colors.white, // Text color
      icon: const Icon(Icons.error, color: Colors.white), // Error Icon
      duration: const Duration(seconds: 3), // Duration for snackbar visibility
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}
