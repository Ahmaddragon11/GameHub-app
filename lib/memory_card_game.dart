import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryCardGameScreen extends StatefulWidget {
  const MemoryCardGameScreen({super.key});

  @override
  State<MemoryCardGameScreen> createState() => _MemoryCardGameScreenState();
}

class _MemoryCardGameScreenState extends State<MemoryCardGameScreen> {
  late List<CardModel> _cards;
  late int _score;
  late int _pairsFound;
  CardModel? _tappedCard1;
  CardModel? _tappedCard2;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _score = 100;
    _pairsFound = 0;
    _tappedCard1 = null;
    _tappedCard2 = null;
    _isProcessing = false;
    _cards = _createShuffledDeck();
    setState(() {});
  }

  List<CardModel> _createShuffledDeck() {
    List<IconData> icons = [
      Icons.favorite,
      Icons.star,
      Icons.anchor,
      Icons.bug_report,
      Icons.camera,
      Icons.lightbulb,
      Icons.palette,
      Icons.widgets,
    ];
    List<CardModel> cards = [];
    for (var icon in icons) {
      cards.add(CardModel(icon: icon));
      cards.add(CardModel(icon: icon));
    }
    cards.shuffle();
    return cards;
  }

  void _onCardTapped(CardModel card) {
    if (_isProcessing || card.isFaceUp || card.isMatched) return;

    setState(() {
      card.isFaceUp = true;

      if (_tappedCard1 == null) {
        _tappedCard1 = card;
      } else {
        _tappedCard2 = card;
        _isProcessing = true;
        _checkForMatch();
      }
    });
  }

  void _checkForMatch() {
    if (_tappedCard1!.icon == _tappedCard2!.icon) {
      // Match found
      setState(() {
        _tappedCard1!.isMatched = true;
        _tappedCard2!.isMatched = true;
        _pairsFound++;
        _score += 20; // Bonus for finding a pair
      });

      if (_pairsFound == 8) {
        // Game over
        _showGameOverDialog(true);
      }

      _resetTappedCards();
    } else {
      // No match
      setState(() {
        _score -= 5; // Penalty for a mismatch
      });

      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          _tappedCard1!.isFaceUp = false;
          _tappedCard2!.isFaceUp = false;
        });
        _resetTappedCards();
      });
    }
  }

  void _resetTappedCards() {
    _tappedCard1 = null;
    _tappedCard2 = null;
    _isProcessing = false;
  }

  void _showGameOverDialog(bool won) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          won ? 'You Win!' : 'Game Over',
          style: GoogleFonts.orbitron(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Your final score: $_score',
          style: GoogleFonts.openSans(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.orbitron(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Card Game'), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cyberpunk_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Score: $_score',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pairs: $_pairsFound / 8',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return MemoryCard(
                    card: _cards[index],
                    onTap: () => _onCardTapped(_cards[index]),
                  );
                },
              ).animate().fadeIn(duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const MemoryCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: card.isFaceUp
              ? Theme.of(context).cardColor
              : Theme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: card.isFaceUp
              ? Icon(
                  card.icon,
                  size: 50,
                  color: card.isMatched
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
      ),
    );
  }
}

class CardModel {
  final IconData icon;
  bool isFaceUp = false;
  bool isMatched = false;

  CardModel({required this.icon});
}
