import 'package:flutter/material.dart';

enum GameMode {
  vsAI,
  twoPlayer,
}

extension GameModeExtension on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.vsAI:
        return 'لاعب ضد الكمبيوتر';
      case GameMode.twoPlayer:
        return 'لاعب ضد لاعب';
    }
  }

  String get description {
    switch (this) {
      case GameMode.vsAI:
        return 'تحدى الذكاء الاصطناعي';
      case GameMode.twoPlayer:
        return 'العب ضد صديقك';
    }
  }

  String get databaseKey {
    switch (this) {
      case GameMode.vsAI:
        return 'single_player'; // Still use single_player for database key
      case GameMode.twoPlayer:
        return 'two_player';
    }
  }

  IconData get icon {
    switch (this) {
      case GameMode.vsAI:
        return Icons.computer;
      case GameMode.twoPlayer:
        return Icons.people;
    }
  }
}
