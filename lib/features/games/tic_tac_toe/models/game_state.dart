enum GameState {
  modeSelection,
  playing,
  gameOver,
}

extension GameStateExtension on GameState {
  bool get isPlaying => this == GameState.playing;
  bool get canPlay => this == GameState.playing;
  
  String get displayText {
    switch(this) {
      case GameState.modeSelection:
        return 'اختر وضع اللعب';
      case GameState.playing:
        return 'اللعبة جارية';
      case GameState.gameOver:
        return 'انتهت اللعبة';
    }
  }
}
