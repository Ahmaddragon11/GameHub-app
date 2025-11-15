import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/services/database_service.dart';
import '../models/game_mode.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class TicTacToeController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  String? _userId;

  final RxList<RxList<Rx<Player?>>> board = RxList.generate(
    3,
    (_) => RxList.generate(3, (_) => Rx<Player?>(null)),
  );
  final Rx<Player?> currentPlayer = Rx<Player?>(Player.X);
  final Rx<GameState> gameState = Rx<GameState>(GameState.modeSelection);
  final Rx<Player?> winner = Rx<Player?>(null);
  final Rx<GameMode> gameMode = Rx<GameMode>(GameMode.twoPlayer);

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    _userId = await _databaseService.getOrCreateUser();
  }

  void startGame(GameMode mode) {
    gameMode.value = mode;
    resetGame();
    gameState.value = GameState.playing;
  }

  void makeMove(int row, int col) {
    if (gameState.value != GameState.playing || board[row][col].value != null) {
      return;
    }

    board[row][col].value = currentPlayer.value;

    if (_checkWinner(row, col)) {
      winner.value = currentPlayer.value;
      gameState.value = GameState.gameOver;
      _updateGameStatistics(winner.value!);
    } else if (_checkDraw()) {
      gameState.value = GameState.gameOver;
      _updateGameStatistics(null); // It's a draw
    } else {
      _switchPlayer();
      if (gameMode.value == GameMode.vsAI && currentPlayer.value == Player.O) {
        _aiMove();
      }
    }
  }

  void _switchPlayer() {
    currentPlayer.value = currentPlayer.value == Player.X ? Player.O : Player.X;
  }

  bool _checkWinner(int row, int col) {
    final player = board[row][col].value;
    // Check row
    if (board[row][0].value == player && board[row][1].value == player && board[row][2].value == player) return true;
    // Check column
    if (board[0][col].value == player && board[1][col].value == player && board[2][col].value == player) return true;
    // Check diagonals
    if (board[0][0].value == player && board[1][1].value == player && board[2][2].value == player) return true;
    if (board[0][2].value == player && board[1][1].value == player && board[2][0].value == player) return true;
    return false;
  }

  bool _checkDraw() {
    for (var r in board) {
      for (var cell in r) {
        if (cell.value == null) {
          return false;
        }
      }
    }
    return true;
  }

  void _aiMove() {
    // Simple AI: find first empty spot
    Timer(const Duration(milliseconds: 500), () {
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          if (board[r][c].value == null) {
            makeMove(r, c);
            return;
          }
        }
      }
    });
  }

  Future<void> _updateGameStatistics(Player? gameWinner) async {
    if (_userId == null) return;

    String modeString = gameMode.value == GameMode.twoPlayer ? 'two_player' : 'single_player';

    if (gameWinner == null) {
      // Draw
      await _databaseService.incrementStatistic('Tic Tac Toe', modeString, 'draws');
    } else if (gameWinner == Player.X) {
      // Player X wins
      await _databaseService.incrementStatistic('Tic Tac Toe', modeString, 'wins');
    } else {
      // Player O (AI) wins
      await _databaseService.incrementStatistic('Tic Tac Toe', modeString, 'losses');
    }
  }

  void resetGame() {
    for (var r in board) {
      for (var cell in r) {
        cell.value = null;
      }
    }
    currentPlayer.value = Player.X;
    winner.value = null;
    gameState.value = GameState.modeSelection; // Go back to mode selection
  }
}
