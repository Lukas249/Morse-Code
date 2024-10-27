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

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_up_rounded, color: Colors.black),
            selectedIcon: Icon(Icons.arrow_circle_up_rounded, color: Colors.white),
            label: 'Encode',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_down_rounded, color: Colors.black),
            selectedIcon: Icon(Icons.arrow_circle_down_rounded, color: Colors.white),
            label: 'Decode',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: Colors.black),
            selectedIcon: Icon(Icons.settings, color: Colors.white),
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