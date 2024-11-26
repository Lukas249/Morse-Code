import 'package:flutter/material.dart';

import 'decode/decode_screen.dart';
import 'encode/encode_screen.dart';
import 'settings/settings_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(Icons.arrow_circle_up_rounded),
            selectedIcon: Icon(Icons.arrow_circle_up_rounded, color: theme.colorScheme.onPrimary,),
            label: 'Encode',
          ),
          NavigationDestination(
            icon: const Icon(Icons.arrow_circle_down_rounded),
            selectedIcon: Icon(Icons.arrow_circle_down_rounded, color: theme.colorScheme.onPrimary),
            label: 'Decode',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings, color: theme.colorScheme.onPrimary),
            label: 'Settings',
          ),
        ],
      ),
      body: const <Widget>[
        EncodeScreen(),
        DecodeScreen(),
        SettingsScreen(),
      ][currentPageIndex],
    );
  }
}