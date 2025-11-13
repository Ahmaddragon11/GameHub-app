import 'package:shared_preferences/shared_preferences.dart';

class HighScoreManager {

  Future<int> getHighScore(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'high_score_$gameId';
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setHighScore(String gameId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'high_score_$gameId';
    await prefs.setInt(key, score);
  }
}
