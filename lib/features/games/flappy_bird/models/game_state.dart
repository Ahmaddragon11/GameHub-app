enum GameState {
  idle,
  playing,
  paused,
  gameOver,
}

extension GameStateX on GameState {
  bool get isActive => this == GameState.playing;
  bool get canPause => this == GameState.playing || this == GameState.paused;
}
