# Classic Games Arcade

A modern Flutter-based mobile application that brings a collection of classic arcade games to your fingertips. This project showcases a robust and scalable architecture, seamless Firebase integration, and a polished user experience.

## 🚀 Features

- **🎮 Multiple Games**: Enjoy a variety of timeless classics, including:
  - **Snake**: Navigate the growing snake to eat food and avoid collisions.
  - **Flappy Bird**: Tap to keep the bird afloat and pass through the pipes.
  - **Tic Tac Toe**: Challenge a friend or the AI in this strategic game.
- **🏆 Local High Scores**: Keep track of your personal bests and compete against yourself.
- **👤 Guest & Authenticated Access**:
  - **Guest Mode**: Jump right into the action without creating an account.
  - **Firebase Authentication**: Securely sign up and log in using your email and password.
  - **Seamless Account Conversion**: Effortlessly convert your guest account to a full user account without losing any of your progress or high scores.
- **📊 User Profiles**: View detailed statistics and track your gaming performance over time.
- **📱 Responsive Design**: A fluid and adaptive UI that looks great on any device.

## 🛠️ Technical Structure

The project is built with a focus on clean architecture and separation of concerns, organized into the following main directories:

- `lib/app`: Contains app-level configurations, including routes and bindings.
- `lib/core`: Holds the core components of the application, such as services, models, and constants.
- `lib/features`: Each feature (e.g., `home`, `auth`, `profile`, `games`) is encapsulated in its own dedicated folder.
- `lib/shared`: Includes shared widgets and utilities that are used across multiple features.

### Core Services

- **AuthService**: Manages all user authentication flows, from guest access to email/password registration, powered by Firebase Auth.
- **DatabaseService**: Handles all interactions with the local SQLite database, storing game data and user statistics.
- **StorageService**: A lightweight key-value storage solution for managing session data.

## 🔑 Authentication System

The app features a sophisticated authentication system with the following capabilities:

- **Guest Mode**: New users are automatically signed in as guests, allowing them to start playing and setting high scores immediately.
- **Email & Password Registration**: Users can create a permanent account to securely save their data and access it from any device.
- **Guest Account Linking**: When a guest user decides to register, all their existing game data—including scores and statistics—is seamlessly migrated to their new account.

## 📈 User Profile

The profile screen provides a comprehensive overview of a user's gaming activity, including:

- Total games played
- Total wins and win rate
- High scores for each game
- Detailed statistics for games like Tic Tac Toe, including wins, losses, and draws for each mode.

## 🔥 Firebase Setup

To run this project with full Firebase integration, follow these steps:

1.  **Create a new Firebase project** in the [Firebase Console](https://console.firebase.google.com/).
2.  **Add an Android and/or iOS app** to your Firebase project.
3.  **Download the configuration file** (`google-services.json` for Android or `GoogleService-Info.plist` for iOS) and place it in the appropriate directory in your project.
4.  **Enable Email/Password authentication** in the **Authentication** section of the Firebase Console.
5.  **Ensure you have the necessary Firebase dependencies** in your `pubspec.yaml` file.

## 🚀 Getting Started

This project serves as a comprehensive starting point for a modern Flutter application.

If this is your first Flutter project, here are a few resources to help you get started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For additional help with Flutter development, check out the official [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
