import 'package:get/get.dart';
import 'package:myapp/core/models/user_model.dart';
import 'package:myapp/core/services/auth_service.dart';
import 'package:myapp/core/services/database_service.dart';
import 'package:myapp/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final DatabaseService _dbService = Get.find<DatabaseService>();

  final user = Rx<UserModel?>(null);
  final isLoading = false.obs;

  final totalGamesPlayed = 0.obs;
  final snakeHighScore = 0.obs;
  final flappyBirdHighScore = 0.obs;
  final ticTacToeStats = <String, dynamic>{}.obs;
  final allStatistics = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadStatistics();
  }

  void loadUserData() {
    user.value = _authService.userModel.value;
  }

  Future<void> loadStatistics() async {
    isLoading.value = true;
    final userId = user.value?.id;
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    totalGamesPlayed.value = await _dbService.getTotalGamesPlayed(userId);
    snakeHighScore.value = await _dbService.getHighScore('snake');
    flappyBirdHighScore.value = await _dbService.getHighScore('flappy_bird');
    allStatistics.value = await _dbService.getAllUserStatistics(userId);

    // Process Tic Tac Toe stats
    final ticTacToeData = allStatistics.where((stat) => stat['game_name'] == 'tic_tac_toe').toList();
    final statsMap = <String, dynamic>{};
    for (var stat in ticTacToeData) {
      statsMap[stat['mode']] = {
        'wins': stat['wins'],
        'losses': stat['losses'],
        'draws': stat['draws'],
      };
    }
    ticTacToeStats.value = statsMap;

    isLoading.value = false;
  }

  Future<void> refreshData() async {
    loadUserData();
    await loadStatistics();
  }

  Future<void> logout() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.home);
  }

  void navigateToAuth() {
    Get.toNamed(AppRoutes.login);
  }

  int get totalWins {
    return allStatistics.fold(0, (sum, stat) => sum + (stat['wins'] as int));
  }

  int get totalLosses {
    return allStatistics.fold(0, (sum, stat) => sum + (stat['losses'] as int));
  }

  double get winRate {
    if (totalGamesPlayed.value == 0) return 0.0;
    return (totalWins / totalGamesPlayed.value) * 100;
  }
}
