import 'package:flutter/material.dart';
import 'package:morse_code/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: provider.toggleTheme,
            child: const Text('Change Theme')
        ),
      ),
    );
  }

}