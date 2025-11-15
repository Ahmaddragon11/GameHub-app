import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

abstract class Helpers {
  /// Generates a unique v4 UUID.
  static String generateUUID() {
    return const Uuid().v4();
  }

  /// Formats a DateTime object into a user-friendly string (e.g., 'dd MMM yyyy').
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats an integer score with commas for thousands.
  static String formatScore(int score) {
    return NumberFormat('#,###').format(score);
  }

  /// Validates if the given string is a valid email address.
  static bool isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  /// Shows a snackbar message using GetX.
  static void showSnackbar(String message, {bool isError = false}) {
    if (Get.isSnackbarOpen) return;
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      ),
    );
  }

  /// Shows a loading indicator dialog.
  static void showLoading() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  /// Hides the currently shown dialog.
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
