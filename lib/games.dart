import 'package:flutter/material.dart';

class Game {
  final String title;
  final String description;
  final IconData icon;
  final String backgroundImage;
  final String route;

  Game({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundImage,
    required this.route,
  });
}

final List<Game> games = [
  Game(
    title: 'Snake',
    description:
        'A classic arcade game where you control a snake to eat fruits and grow longer.',
    icon: Icons.fastfood,
    backgroundImage: 'assets/images/snake.png',
    route: '/snake',
  ),
  Game(
    title: 'Tic-Tac-Toe',
    description:
        'A two-player game where you take turns marking spaces in a 3x3 grid.',
    icon: Icons.close,
    backgroundImage: 'assets/images/tic_tac_toe.png',
    route: '/tic_tac_toe',
  ),
  Game(
    title: 'Flappy Bird',
    description:
        'A side-scrolling game where you control a bird, attempting to fly between columns of green pipes without hitting them.',
    icon: Icons.flight,
    backgroundImage: 'assets/images/flappy_bird.png',
    route: '/flappy_bird',
  ),
  Game(
    title: 'Pong',
    description:
        'A table tennis-themed arcade game featuring two-dimensional graphics.',
    icon: Icons.sports_tennis,
    backgroundImage: 'assets/images/pong.png',
    route: '/pong',
  ),
  Game(
    title: 'Memory Card Game',
    description: 'A classic memory game where you match pairs of cards.',
    icon: Icons.memory,
    backgroundImage: 'assets/images/memory_card.png',
    route: '/memory_card_game',
  ),
];
