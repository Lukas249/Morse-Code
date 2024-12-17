import 'package:flutter/material.dart';
import 'package:morse_code/provider/theme_provider.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> textSections = [
  {
    'text': "Instructions:",
    'style': TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  },
  {
    'text': "\nEncode:\n",
    'style': TextStyle(fontWeight: FontWeight.bold),
  },
  {
    'text': "- Just type a sentence using only alphanumeric characters.\n",
  },
  {
    'text': "\nDecode:\n",
    'style': TextStyle(fontWeight: FontWeight.bold),
  },
  {
    'text': "1. Chat:\n",
    'style': TextStyle(fontWeight: FontWeight.bold),
  },
  {
    'text': "- Type a sentence in Morse code using only '.', '-' and spaces.\n",
  },
  {
    'text': "2. Flashlight:\n",
    'style': TextStyle(fontWeight: FontWeight.bold),
  },
  {
    'text': "- Point the camera at the source where the Morse code is being broadcast to read the characters correctly.\n- Zoom in for more accurate reading.\n",
  },
  {
    'text': "- Currently, decoding begins without a calibration step. To ensure accurate detection, the luminance value should exceed 200 during character transmission.\n"
  },
  {
    'text': "3. Sound:\n",
    'style': TextStyle(fontWeight: FontWeight.bold),
  },
  {
    'text': "- For the sound to be read correctly, it is best to use our encoder to encode text into sound.\n- The decibel value must exceed 64 decibels during character transmission.\n",
  },
];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        children: [
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary
              ),
              onPressed: provider.toggleTheme,
              child: const Text(
                'Change Theme',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ), // Add spacing between buttons and container
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  height: 1.5, // Line height for better readability
                ),
                children: textSections.map((section) {
                  return TextSpan(
                    text: section['text'] as String,
                    style: section['style'] as TextStyle?,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
