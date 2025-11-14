import 'package:get/get.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/models/game_model.dart'; // Assuming GameModel is used for leaderboard entries

class LeaderboardController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final RxBool isLoading = true.obs;
  final RxList<GameScoreModel> leaderboardEntries = RxList<GameScoreModel>();

  @override
  void onInit() {
    super.onInit();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      isLoading.value = true;
      // This is a placeholder. Real leaderboard would fetch from a global source (e.g., Firebase Firestore)
      // For now, we'll simulate some data or fetch from local scores if available.
      // Assuming DatabaseService has a method to get all scores for all users (not just current user)
      // This would typically involve a cloud database for a global leaderboard.
      
      // For demonstration, let's create some dummy data or fetch from local scores
      // if DatabaseService had a method like getAllGameScores()
      // For now, we'll just clear and add some dummy data.
      leaderboardEntries.clear();
      leaderboardEntries.add(GameScoreModel(id: 1, userId: 'user1', gameName: 'Snake', score: 150, createdAt: DateTime.now().toIso8601String(), username: 'PlayerOne'));
      leaderboardEntries.add(GameScoreModel(id: 2, userId: 'user2', gameName: 'Flappy Bird', score: 200, createdAt: DateTime.now().toIso8601String(), username: 'BirdMaster'));
      leaderboardEntries.add(GameScoreModel(id: 3, userId: 'user3', gameName: 'Tic Tac Toe', score: 10, createdAt: DateTime.now().toIso8601String(), username: 'TicTacToePro'));
      leaderboardEntries.add(GameScoreModel(id: 4, userId: 'user1', gameName: 'Flappy Bird', score: 180, createdAt: DateTime.now().toIso8601String(), username: 'PlayerOne'));

      // Sort by score descending
      leaderboardEntries.sort((a, b) => b.score.compareTo(a.score));

    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل قائمة الصدارة: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}

// Placeholder for GameScoreModel, assuming it exists or needs to be created
class GameScoreModel {
  final int id;
  final String userId;
  final String gameName;
  final int score;
  final String createdAt;
  final String username; // Added for leaderboard display

  GameScoreModel({
    required this.id,
    required this.userId,
    required this.gameName,
    required this.score,
    required this.createdAt,
    required this.username,
  });

  factory GameScoreModel.fromMap(Map<String, dynamic> map) {
    return GameScoreModel(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      gameName: map['game_name'] as String,
      score: map['score'] as int,
      createdAt: map['created_at'] as String,
      username: map['username'] as String, // Assuming username is also fetched
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'game_name': gameName,
      'score': score,
      'created_at': createdAt,
      'username': username,
    };
  }
}
