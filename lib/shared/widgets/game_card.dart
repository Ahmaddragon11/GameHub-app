import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:myapp/games.dart';

class GameCard extends StatefulWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  void _onTap() {
    HapticFeedback.lightImpact();
    context.go(widget.game.route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: _onTap,
          child: Card(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    image: DecorationImage(
                      image: AssetImage(widget.game.backgroundImage),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(153),
                        BlendMode.darken,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withAlpha(77),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Icon(
                      widget.game.icon,
                      size: 60.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.game.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.game.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(
          delay: 2000.ms,
          duration: 1000.ms,
          color: Theme.of(context).colorScheme.secondary.withAlpha(51),
        );
  }
}
