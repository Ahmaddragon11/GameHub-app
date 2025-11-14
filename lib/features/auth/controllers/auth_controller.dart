import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/core/services/auth_service.dart';
import 'package:myapp/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    if (!RegExp(AppConstants.emailRegex).hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'كلمة المرور يجب أن تكون ${AppConstants.minPasswordLength} أحرف على الأقل';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال اسم المستخدم';
    }
    if (value.length < AppConstants.usernameMinLength) {
      return 'اسم المستخدم قصير جداً';
    }
    if (value.length > AppConstants.usernameMaxLength) {
      return 'اسم المستخدم طويل جداً';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await _authService.signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'نجاح',
          'تم تسجيل الدخول بنجاح!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } on String catch (e) {
        Get.snackbar(
          'خطأ',
          e,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await _authService.signUpWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
          usernameController.text.trim(),
        );
        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } on String catch (e) {
        Get.snackbar(
          'خطأ',
          e,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await _authService.sendPasswordResetEmail(
          emailController.text.trim(),
        );
        Get.back(); // Go back to login screen
        Get.snackbar(
          'نجاح',
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } on String catch (e) {
        Get.snackbar(
          'خطأ',
          e,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void navigateToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void navigateToLogin() {
    Get.back();
  }

  void skipLogin() {
    Get.offAllNamed(AppRoutes.home);
  }
}
