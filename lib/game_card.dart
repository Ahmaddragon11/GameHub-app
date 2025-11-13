import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String image;
  final String route;

  const GameCard({
    super.key,
    required this.title,
    required this.image,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 80,
              width: 80,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.gamepad, size: 80),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
