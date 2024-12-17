import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MorseCodeApp()));
}

class MorseCodeApp extends StatelessWidget {
  const MorseCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
            theme: provider.theme,
            home: const SafeArea(child: Navigation())
        );
      },
    );
  }
}
