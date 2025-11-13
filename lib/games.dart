import 'package:flutter/material.dart';

class Game {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final String backgroundImage;

  Game({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.backgroundImage,
  });
}

final List<Game> games = [
  Game(
    title: 'Snake',
    description: 'Eat the food, grow the snake',
    icon: Icons.gesture, // More dynamic icon
    route: '/snake',
    backgroundImage: 'assets/images/snake_background.png',
  ),
  Game(
    title: 'Tic Tac Toe',
    description: 'X\'s and O\'s',
    icon: Icons.close, // More direct representation
    route: '/tic_tac_toe',
    backgroundImage: 'assets/images/tic_tac_toe_background.png',
  ),
  Game(
    title: 'Flappy Bird',
    description: 'Tap to fly',
    icon: Icons.flight_takeoff, // More thematic icon
    route: '/flappy_bird',
    backgroundImage: 'assets/images/flappy_bird_background.png',
  ),
  Game(
    title: 'Pong',
    description: 'The original arcade classic',
    icon: Icons.sports_tennis, // A fitting icon for Pong
    route: '/pong',
    backgroundImage: 'assets/images/pong_background.png',
  ),
];
