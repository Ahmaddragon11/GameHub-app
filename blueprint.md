
# Project Blueprint

## Overview

This document outlines the structure, design, and features of the Flutter application. It serves as a single source of truth for the project's architecture and development plan.

## Current State

The project is a default Flutter application with the following structure:

- `pubspec.yaml`: Contains basic dependencies like `cupertino_icons` and `flutter_lints`.
- `lib/`: Contains all the Dart code, including the main entry point (`main.dart`) and several game files.
- `test/`: Contains the default widget test.

## Enhancement Plan

The following steps will be taken to improve the project's structure, appearance, and overall quality:

1.  **Add Dependencies:**
    *   `provider` for state management.
    *   `google_fonts` for custom fonts.

2.  **Restructure Project:**
    *   Create a `core` directory for shared components like theme and providers.
    *   Create a `features` directory to house the different application features.
    *   Create a `shared` directory for widgets and other code shared across features.
    *   Create a `screens` directory inside of `features` for each feature's screens.
    *   Move game-related files into the `features` directory.

3.  **Implement Theming:**
    *   Create a `theme.dart` file in the `core` directory.
    *   Define a `ThemeData` object with a custom color scheme and typography using `google_fonts`.
    *   Implement a `ThemeProvider` to allow for theme toggling (light/dark mode).

4.  **Refactor `main.dart`:**
    *   Update the `main` function to initialize `ChangeNotifierProvider` for the `ThemeProvider`.
    *   Update `MyApp` to use `Consumer<ThemeProvider>` to apply the theme.
    *   Replace the `MyHomePage` with a new `HomeScreen` widget.

5.  **Create a Home Screen:**
    *   Create a `home_screen.dart` file in `lib/features/home/screens`.
    *   Implement a `HomeScreen` widget with a basic layout and a theme toggle button.

6.  **Update `analysis_options.yaml`:**
    *   Enable additional lints to enforce stricter code quality.

7.  **Run `flutter pub get`:**
    *   Install the new dependencies.

8.  **Run `dart format .`:**
    *   Format the code according to Dart's style guidelines.
