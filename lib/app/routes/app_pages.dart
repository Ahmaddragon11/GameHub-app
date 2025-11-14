import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app_routes.dart';

// --- Placeholders ---
// These will be moved to their respective feature folders later.

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // A simple placeholder. In a real app, this would have a logo
    // and navigate to the home screen after some delay or initialization.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to the Classic Games App!'),
      ),
    );
  }
}

// Bindings will be moved to the `bindings` folder.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Example: Get.lazyPut<HomeController>(() => HomeController());
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Example: Get.lazyPut<SplashController>(() => SplashController());
  }
}

// --- App Pages ---

abstract class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
