import 'package:flutter/material.dart';
import 'package:morse_code/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// loop option
int loop = 1;
void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Błąd"),
      content: Text("Podaj poprawną liczbę!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
// loop option

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the left
        children: [
          SizedBox(
            height: screenHeight * 0.10, // 15% of screen height
            width: screenWidth * 0.45, // 15% of screen width
            child: ElevatedButton(
              onPressed: provider.toggleTheme,
              child: const Text(
                'Change Theme',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Add spacing between buttons
          SizedBox(
            height: screenHeight * 0.10,
            width: screenWidth * 0.45,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Change Speed',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          TextField(
            style: TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              label: Text('  Loop', style: TextStyle(fontSize: 20, ),),
            ),
            onSubmitted: (value){
                try {
                  loop = int.parse(value);
                }
                catch (e) {
                  loop = 1;
                  _showErrorDialog(context);
                }
            },
          ),
          const SizedBox(
              height: 10), // Add spacing between buttons and container
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.onSurface.withOpacity(0.1),
              ),
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                      height: 1.5, // Line height for better readability
                    ),
                    children: const[
                      TextSpan(
                        text: "Instructions:\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextSpan(
                        text: "\nEncode:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "- Just type a sentence using only alphanumeric characters.\n",
                      ),
                      TextSpan(
                        text: "\nDecode:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "1. Chat:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "- Type a sentence in Morse code using only '.', '-' and spaces.\n",
                      ),
                      TextSpan(
                        text: "2. Flashlight:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "- Point the camera at the source where the Morse code is being broadcast to read the characters correctly.\n"
                            "- Zoom in for more accurate reading.\n",
                      ),
                      TextSpan(
                        text: "3. Sound:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "- For the sound to be read correctly, it is best to use our encoder to encode text into sound.\n"
                            "- The decibel value must exceed 64 decibels during character transmission.\n",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
