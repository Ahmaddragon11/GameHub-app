import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/games.dart';
import 'package:myapp/shared/widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameHub'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/cyberpunk_background.png',
            ), // New background
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(24.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24.0,
            mainAxisSpacing: 24.0,
            childAspectRatio: 0.75,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameCard(game: game)
                .animate()
                .fadeIn(duration: 800.ms, delay: (300 * index).ms)
                .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic);
          },
        ),
      ),
    );
  }
}
