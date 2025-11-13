import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/home/screens/home_screen.dart';
import 'package:myapp/snake_game.dart';
import 'package:myapp/tic_tac_toe_game.dart';
import 'package:myapp/flappy_bird_game.dart';
import 'package:myapp/pong_game.dart';
import 'package:myapp/memory_card_game.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'snake',
            builder: (BuildContext context, GoRouterState state) {
              return const SnakeGameScreen();
            },
          ),
          GoRoute(
            path: 'tic_tac_toe',
            builder: (BuildContext context, GoRouterState state) {
              return const TicTacToeGameScreen();
            },
          ),
          GoRoute(
            path: 'flappy_bird',
            builder: (BuildContext context, GoRouterState state) {
              return const FlappyBirdGameScreen();
            },
          ),
          GoRoute(
            path: 'pong',
            builder: (BuildContext context, GoRouterState state) {
              return const PongGameScreen();
            },
          ),
          GoRoute(
            path: 'memory_card_game',
            builder: (BuildContext context, GoRouterState state) {
              return const MemoryCardGameScreen();
            },
          ),
        ],
      ),
    ],
  );
}
