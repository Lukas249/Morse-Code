import 'package:flutter/material.dart';
import 'pages/navigation.dart';

void main() {
  runApp(const MorseCodeApp());
}

class MorseCodeApp extends StatelessWidget {
  const MorseCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const SafeArea(child: Navigation()),
    );
  }
}
