import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: ThemeMode.dark, // Replace with your theme provider
              onChanged: (ThemeMode? newValue) {
                // Handle theme change
              },
              items: ThemeMode.values
                  .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
                return DropdownMenuItem<ThemeMode>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Sound'),
            trailing: Switch(
              value: true, // Replace with your sound provider
              onChanged: (bool value) {
                // Handle sound change
              },
            ),
          ),
        ],
      ),
    );
  }
}
