import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/home/views/home_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/games/snake/views/snake_view.dart';
import '../../features/games/snake/bindings/snake_binding.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const HomeView(), // Or a splash screen
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.snake,
      page: () => const SnakeView(),
      binding: SnakeBinding(),
    ),
    GetPage(name: AppRoutes.flappyBird, page: () => const PlaceholderGameScreen(gameName: 'Flappy Bird')),
    GetPage(name: AppRoutes.ticTacToe, page: () => const PlaceholderGameScreen(gameName: 'Tic Tac Toe')),
    GetPage(name: AppRoutes.profile, page: () => const PlaceholderScreen(title: 'الملف الشخصي')),
    GetPage(name: AppRoutes.settings, page: () => const PlaceholderScreen(title: 'الإعدادات')),
    GetPage(name: AppRoutes.leaderboard, page: () => const PlaceholderScreen(title: 'قائمة الصدارة')),
    GetPage(name: AppRoutes.chat, page: () => const PlaceholderScreen(title: 'الدردشة')),
  ];
}

// Placeholder for general screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('قريباً: $title', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

// Placeholder for game screens
class PlaceholderGameScreen extends StatelessWidget {
  final String gameName;
  const PlaceholderGameScreen({super.key, required this.gameName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gameName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('اللعبة قيد التطوير: $gameName', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}
