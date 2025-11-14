# Classic Games Arcade

A Flutter project that brings classic arcade games to your fingertips.

## Features

- **Multiple Games**: Enjoy classic games like Snake, Flappy Bird, and Tic Tac Toe.
- **Local High Scores**: Track your personal best scores for each game.
- **Guest Mode**: Start playing immediately without needing to create an account.
- **Firebase Authentication**: Securely sign up and log in with your email and password.
- **Seamless Guest to User Conversion**: Register your guest account to save your progress without losing any data.
- **User Profile**: View your game statistics and personal information.
- **Responsive Design**: Play on any device with a smooth and adaptive UI.
- **State Management with GetX**: A fast, stable, and scalable state management solution.

## Technical Structure

The project is organized into the following main directories:

- `lib/app`: Contains app-level configurations like routes and bindings.
- `lib/core`: Holds core components like services, models, and constants.
- `lib/features`: Each feature (e.g., `home`, `auth`, `profile`, `games`) has its own dedicated folder.
- `lib/shared`: Includes shared widgets and utilities used across the app.

### Core Services

- `AuthService`: Manages user authentication with Firebase Auth.
- `DatabaseService`: Handles all interactions with the local SQLite database.
- `StorageService`: A simple key-value storage for session data.

## Authentication System

The app features a robust authentication system with the following capabilities:

- **Guest Mode**: New users are automatically signed in as guests, allowing them to play and set high scores.
- **Email & Password Registration**: Users can create a permanent account to save their data.
- **Guest Account Linking**: When a guest user registers, all their existing game data (scores and statistics) is seamlessly migrated to their new account.

## User Profile

The profile screen provides a comprehensive overview of the user's activity, including:

- Total games played
- Total wins and win rate
- High scores for each game
- Detailed statistics for games like Tic Tac Toe (wins, losses, draws for each mode)

## Firebase Setup

To run this project with Firebase integration, you need to:

1.  Create a new Firebase project.
2.  Add an Android and/or iOS app to your Firebase project.
3.  Follow the instructions to add the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file to your project.
4.  In the Firebase Console, enable **Email/Password** authentication under the **Authentication** section.
5.  Ensure you have the necessary Firebase dependencies in your `pubspec.yaml` file.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
