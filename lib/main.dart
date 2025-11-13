import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'firebase_options.dart';
import 'package:myapp/games.dart';
import 'package:myapp/snake_game.dart';
import 'package:myapp/tic_tac_toe_game.dart';
import 'package:myapp/flappy_bird_game.dart';
import 'package:myapp/pong_game.dart'; // Import the new pong game

// 1. Router Configuration
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
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
          path: 'pong', // Add the pong route
          builder: (BuildContext context, GoRouterState state) {
            return const PongGameScreen();
          },
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // In debug mode, crashlytics will not be initialized
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// 2. ThemeProvider Class
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark theme

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// 3. Main Application Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6200EE);
    const Color secondaryColor = Color(0xFF03DAC6);

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.orbitron(fontSize: 57, fontWeight: FontWeight.bold, color: primaryColor),
      titleLarge: GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
      labelLarge: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );

    final cardTheme = CardThemeData(
      elevation: 12,
      shadowColor: primaryColor.withAlpha(128),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(color: secondaryColor.withAlpha(178), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[900]?.withAlpha(204),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: elevatedButtonTheme,
      cardTheme: cardTheme,
      iconTheme: const IconThemeData(color: secondaryColor),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
      ),
      textTheme: appTextTheme.apply(bodyColor: Colors.black, displayColor: primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: elevatedButtonTheme,
      cardTheme: cardTheme.copyWith(color: Colors.white, shadowColor: primaryColor.withAlpha(64)),
      iconTheme: const IconThemeData(color: primaryColor),
    );


    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'GameHub',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// 4. Home Page Widget
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameHub'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cyberpunk_background.png'), // New background
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

// 5. Game Card Widget
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
                  colorFilter: ColorFilter.mode(Colors.black.withAlpha(153), BlendMode.darken),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(77),
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
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
        delay: 2000.ms,
        duration: 1000.ms,
        color: Theme.of(context).colorScheme.secondary.withAlpha(51),
      );
  }
}
