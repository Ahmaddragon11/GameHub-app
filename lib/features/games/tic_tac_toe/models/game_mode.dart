import 'package:flutter/material.dart';

enum GameMode {
  singlePlayer,
  twoPlayer,
}

extension GameModeExtension on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.singlePlayer:
        return 'لاعب واحد';
      case GameMode.twoPlayer:
        return 'لاعبان';
    }
  }

  String get description {
    switch (this) {
      case GameMode.singlePlayer:
        return 'تحدى الذكاء الاصطناعي';
      case GameMode.twoPlayer:
        return 'العب ضد صديقك';
    }
  }

  String get databaseKey {
    switch (this) {
      case GameMode.singlePlayer:
        return 'single_player';
      case GameMode.twoPlayer:
        return 'two_player';
    }
  }

  IconData get icon {
    switch (this) {
      case GameMode.singlePlayer:
        return Icons.computer;
      case GameMode.twoPlayer:
        return Icons.people;
    }
  }
}
