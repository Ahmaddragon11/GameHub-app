import 'package:flutter/material.dart';

@immutable
enum Player {
  X,
  O,
  none,
}

extension PlayerExtension on Player {
  Player get opponent {
    if (this == Player.X) return Player.O;
    if (this == Player.O) return Player.X;
    return Player.none;
  }

  String get symbol {
    if (this == Player.X) return 'X';
    if (this == Player.O) return 'O';
    return '';
  }
  
  String get displayName {
     if (this == Player.X) return 'اللاعب X';
     if (this == Player.O) return 'اللاعب O';
     return '';
  }

  bool get isNone => this == Player.none;
}
