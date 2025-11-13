import 'package:flutter/material.dart';
import 'package:myapp/high_score_manager.dart';

class TicTacToeGameScreen extends StatefulWidget {
  const TicTacToeGameScreen({super.key});

  @override
  State<TicTacToeGameScreen> createState() => _TicTacToeGameScreenState();
}

class _TicTacToeGameScreenState extends State<TicTacToeGameScreen> {
  // Game state
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String? winner;
  int xWins = 0;
  int oWins = 0;

  final HighScoreManager _highScoreManager = HighScoreManager();

  @override
  void initState() {
    super.initState();
    _loadHighScores();
    resetGame();
  }

  Future<void> _loadHighScores() async {
    final loadedXWins = await _highScoreManager.getHighScore('tic_tac_toe_x');
    final loadedOWins = await _highScoreManager.getHighScore('tic_tac_toe_o');
    setState(() {
      xWins = loadedXWins;
      oWins = loadedOWins;
    });
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
    });
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == null) {
      setState(() {
        board[index] = currentPlayer;
        checkWinner();
        if (winner == null) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] != '' &&
          board[i] == board[i + 1] &&
          board[i] == board[i + 2]) {
        winner = board[i];
        _updateScores(winner!);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] != '' &&
          board[i] == board[i + 3] &&
          board[i] == board[i + 6]) {
        winner = board[i];
        _updateScores(winner!);
        return;
      }
    }

    // Check diagonals
    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      winner = board[0];
      _updateScores(winner!);
      return;
    }
    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      winner = board[2];
      _updateScores(winner!);
      return;
    }

    // Check for a draw
    if (!board.contains('')) {
      winner = 'draw';
    }
  }

  void _updateScores(String winner) {
    if (winner == 'X') {
      xWins++;
      _highScoreManager.setHighScore('tic_tac_toe_x', xWins);
    } else if (winner == 'O') {
      oWins++;
      _highScoreManager.setHighScore('tic_tac_toe_o', oWins);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'X Wins: $xWins | O Wins: $oWins',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner == null
                  ? 'Player $currentPlayer\'s Turn'
                  : winner == 'draw'
                  ? 'It\'s a Draw!'
                  : 'Player $winner Wins!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => makeMove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
