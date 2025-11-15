import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/services/auth_service.dart';
import '../../../core/models/game_model.dart';
import '../../../core/services/database_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart'; // Assuming AppTheme is created

class HomeController extends GetxController {
  final isLoading = true.obs;
  final games = <GameModel>[].obs;
  final authService = Get.find<AuthService>();

  final DatabaseService _databaseService = Get.find<DatabaseService>();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    checkAuthStatus();
  }

  Future<void> _loadInitialData() async {
    await _loadGames();
  }

  Future<void> _loadGames() async {
    isLoading(true);
    try {
      final initialGames = [
        GameModel(
          id: 'snake',
          name: 'الأفعى',
          nameEn: 'Snake',
          description: 'اجمع التفاح وتجنب الاصطدام بنفسك',
          descriptionEn: 'Collect apples and avoid hitting yourself',
          iconPath: 'assets/icons/snake_icon.png',
          route: AppRoutes.snake,
          color: AppTheme.gameColors['snake'] ?? Colors.green,
        ),
        GameModel(
          id: 'flappyBird',
          name: 'الطائر المرفرف',
          nameEn: 'Flappy Bird',
          description: 'تجاوز الأنابيب وحافظ على طائرك في الهواء',
          descriptionEn: 'Pass the pipes and keep your bird in the air',
          iconPath: 'assets/icons/flappy_bird_icon.png',
          route: AppRoutes.flappyBird,
          color: AppTheme.gameColors['flappyBird'] ?? Colors.orange,
        ),
        GameModel(
          id: 'ticTacToe',
          name: 'إكس أو',
          nameEn: 'Tic Tac Toe',
          description: 'كن أول من يكون صفًا من ثلاثة للفوز',
          descriptionEn: 'Be the first to form a line of three to win',
          iconPath: 'assets/icons/tic_tac_toe_icon.png',
          route: AppRoutes.ticTacToe,
          color: AppTheme.gameColors['ticTacToe'] ?? Colors.purple,
        ),
      ];

      // Fetch high scores
      for (var game in initialGames) {
        game.highScore = await _databaseService.getHighScore(game.id);
      }

      games.assignAll(initialGames);
    } catch (e) {
      Helpers.showSnackbar('حدث خطأ في تحميل الألعاب: $e', isError: true);
    } finally {
      isLoading(false);
    }
  }

  void checkAuthStatus() {
    if (authService.userModel.value?.isGuest ?? true) {
      Get.snackbar(
        'مرحباً بك!',
        'أنت تلعب كضيف. سجل الآن لحفظ تقدمك!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.login),
          child: const Text('تسجيل', style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  void navigateToGame(String route) {
    Get.toNamed(route);
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void navigateToSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  Future<void> onRefresh() async {
    // Simulate a network delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    await _loadGames();
  }
}
