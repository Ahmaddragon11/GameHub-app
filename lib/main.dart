import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/game_card.dart';
import 'package:myapp/memory_card_game.dart';
import 'package:myapp/pong_game.dart';
import 'package:myapp/settings_screen.dart';
import 'package:myapp/snake_game.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pong',
      builder: (context, state) => const PongGameScreen(),
    ),
    GoRoute(
      path: '/memory-card',
      builder: (context, state) => const MemoryCardGameScreen(),
    ),
    GoRoute(
      path: '/snake',
      builder: (context, state) => const SnakeGameScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'GameHub',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            GameCard(
              title: 'Pong',
              image: 'assets/images/pong.png',
              route: '/pong',
            ),
            GameCard(
              title: 'Memory Card Game',
              image: 'assets/images/memory_card.png',
              route: '/memory-card',
            ),
            GameCard(
              title: 'Snake',
              image: 'assets/images/snake.png',
              route: '/snake',
            ),
          ],
        ),
      ),
    );
  }
}
