import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Language Setting
            ListTile(
              title: const Text('اللغة'),
              trailing: DropdownButton<String>(
                value: controller.currentLocale.value?.languageCode ?? 'en', // Provide a default value
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.changeLanguage(newValue);
                  }
                },
                items: <String>['ar', 'en']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == 'ar' ? 'العربية' : 'English'),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Theme Setting
            ListTile(
              title: const Text('الوضع الليلي'),
              trailing: Switch(
                value: controller.isDarkMode.value,
                onChanged: controller.toggleTheme,
              ),
            ),
            const Divider(),

            // Account Management
            ListTile(
              title: const Text('إدارة الحساب'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to account management screen
                Get.snackbar('قريباً', 'شاشة إدارة الحساب قيد التطوير');
              },
            ),
            const Divider(),

            // Logout
            ListTile(
              title: const Text('تسجيل الخروج'),
              trailing: const Icon(Icons.logout),
              onTap: controller.logout,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
