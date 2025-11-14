enum GameState {
  idle,     // Waiting to start
  playing,  // Game is active
  paused,   // Game is paused
  gameOver, // Game has ended
}

extension GameStateExtension on GameState {
  bool get isActive => this == GameState.playing;
  bool get canPause => this == GameState.playing || this == GameState.paused;

  String get displayText {
    switch (this) {
      case GameState.idle:
        return 'اضغط لبدء اللعبة';
      case GameState.playing:
        return 'اللعبة جارية';
      case GameState.paused:
        return 'اللعبة متوقفة';
      case GameState.gameOver:
        return 'انتهت اللعبة!';
    }
  }
}
