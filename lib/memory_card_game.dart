import 'dart:async';

import 'package:flutter/material.dart';

class MemoryCardGameScreen extends StatefulWidget {
  const MemoryCardGameScreen({super.key});

  @override
  State<MemoryCardGameScreen> createState() => _MemoryCardGameScreenState();
}

class _MemoryCardGameScreenState extends State<MemoryCardGameScreen> {
  final List<String> _emojis = [
    'S',
    'S',
    'B',
    'B',
    'C',
    'C',
    'D',
    'D',
    'E',
    'E',
    'F',
    'F',
    'G',
    'G',
    'H',
    'H',
  ];

  final List<bool> _isFlipped = List.filled(16, false);
  final List<int> _flippedIndexes = [];
  int _matches = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _emojis.shuffle();
  }

  void _onCardTapped(int index) {
    if (_isChecking || _isFlipped[index]) return;

    setState(() {
      _isFlipped[index] = true;
      _flippedIndexes.add(index);
    });

    if (_flippedIndexes.length == 2) {
      _isChecking = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        final firstIndex = _flippedIndexes[0];
        final secondIndex = _flippedIndexes[1];

        if (_emojis[firstIndex] == _emojis[secondIndex]) {
          _matches++;
          if (_matches == 8) {
            _showWinDialog();
          }
        } else {
          setState(() {
            _isFlipped[firstIndex] = false;
            _isFlipped[secondIndex] = false;
          });
        }

        _flippedIndexes.clear();
        _isChecking = false;
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You Win!'),
        content: const Text('You have matched all the cards.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _emojis.shuffle();
      for (int i = 0; i < _isFlipped.length; i++) {
        _isFlipped[i] = false;
      }
      _matches = 0;
      _flippedIndexes.clear();
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Card Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _emojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onCardTapped(index),
            child: Card(
              color: _isFlipped[index] ? Colors.white : Colors.blue,
              child: Center(
                child: Text(
                  _isFlipped[index] ? _emojis[index] : '?',
                  style: TextStyle(
                    fontSize: 40,
                    color: _isFlipped[index] ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
