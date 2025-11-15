abstract class AppConstants {
  // App Information
  static const String appName = 'Classic Games Arcade';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'classic_games.db';
  static const int databaseVersion = 3;

  // Auth Constants
  static const int minPasswordLength = 6;
  static const String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 20;

  // Firebase Firestore Collections
  static const String firestoreUsersCollection = 'users';
  static const String firestoreScoresCollection = 'scores';
  static const String firestoreChatCollection = 'chat';

  // Game Settings
  static const double defaultGameSpeed = 1.0;
  static const int maxLeaderboardEntries = 50;
}
