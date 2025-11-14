import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add your app logo here
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            Text(
              'Classic Games Arcade',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'جار التحميل...',
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
