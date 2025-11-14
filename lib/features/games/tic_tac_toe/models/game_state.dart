enum GameState {
  idle,
  modeSelection,
  playing,
  paused,
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
      case GameState.idle:
        return 'جاهز للعب';
      case GameState.paused:
        return 'متوقف مؤقتًا';
    }
  }
}
