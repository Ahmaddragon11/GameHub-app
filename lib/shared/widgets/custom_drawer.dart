import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/services/auth_service.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return Drawer(
      child: Obx(
        () {
          final user = authService.userModel.value;
          final isGuest = user?.isGuest ?? true;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white70,
                      child: Text(
                        user?.displayName.substring(0, 1).toUpperCase() ?? 'G',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? 'ضيف',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isGuest
                          ? 'قم بالتسجيل لتمييز تقدمك'
                          : user?.email ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.home_outlined,
                title: 'الرئيسية',
                onTap: () {
                  Get.back(); // Close drawer
                  if (Get.currentRoute != AppRoutes.home) {
                    Get.offNamed(AppRoutes.home);
                  }
                },
              ),
              if (isGuest)
                _buildDrawerItem(
                  icon: Icons.login,
                  title: 'تسجيل الدخول / إنشاء حساب',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.login);
                  },
                ),
              _buildDrawerItem(
                icon: Icons.person_outline,
                title: 'الملف الشخصي',
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.profile);
                },
              ),
              _buildDrawerItem(
                icon: Icons.leaderboard_outlined,
                title: 'قائمة الصدارة',
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.leaderboard);
                },
              ),
              _buildDrawerItem(
                icon: Icons.chat_bubble_outline,
                title: 'الدردشة',
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.chat);
                },
              ),
              const Divider(),
              _buildDrawerItem(
                icon: Icons.settings_outlined,
                title: 'الإعدادات',
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.settings);
                },
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                title: 'حول التطبيق',
                onTap: () {
                  Get.back();
                  Get.dialog(
                    AlertDialog(
                      title: const Text(AppConstants.appName),
                      content: const Text(
                          'الإصدار: ${AppConstants.appVersion}\nتم التطوير بواسطة الذكاء الاصطناعي'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('حسناً'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (!isGuest)
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  onTap: () {
                    Get.back();
                    Get.defaultDialog(
                      title: 'تأكيد',
                      middleText: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                      textConfirm: 'نعم',
                      textCancel: 'لا',
                      onConfirm: () => authService.signOut(),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.colorScheme.secondary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
