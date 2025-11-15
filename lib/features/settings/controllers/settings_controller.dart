import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../app/routes/app_routes.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<Locale?> currentLocale = Get.locale.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode');
    if (savedThemeMode == 'dark') {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    } else if (savedThemeMode == 'light') {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      // Default to system theme
      isDarkMode.value = Get.isPlatformDarkMode;
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  void changeLanguage(String languageCode) {
    final newLocale = Locale(languageCode);
    Get.updateLocale(newLocale);
    currentLocale.value = newLocale;
  }

  void toggleTheme(bool value) async {
    isDarkMode.value = value;
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
      await prefs.setString('themeMode', 'dark');
    } else {
      Get.changeThemeMode(ThemeMode.light);
      await prefs.setString('themeMode', 'light');
    }
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login); // Navigate to login after logout
    Get.snackbar('تم تسجيل الخروج', 'لقد تم تسجيل خروجك بنجاح.', snackPosition: SnackPosition.BOTTOM);
  }
}
