import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = Get.find<StorageService>();
    final isGuest = storageService.read<bool>(StorageKeys.isGuest) ?? true;
    final userName = storageService.read<String>(StorageKeys.userId) ?? 'ضيف';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                  backgroundColor: Colors.white70,
                ),
                const SizedBox(height: 12),
                Text(
                  isGuest ? 'مرحباً أيها الضيف' : userName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  isGuest ? 'قم بالتسجيل لتمييز تقدمك' : 'مرحباً بعودتك!',
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
                  content: const Text('الإصدار: ${AppConstants.appVersion}\nتم التطوير بواسطة الذكاء الاصطناعي'),
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
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.colorScheme.secondary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
