import 'package:flutter/material.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:morse_code/pages/decode/sound/decode_morse_code_sound.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({super.key});

  @override
  State<SoundScreen> createState() {
    return SoundScreenState();
  }
}

class SoundScreenState extends State<SoundScreen> {
  final DecodeMorseCodeSound _morseDecoder = DecodeMorseCodeSound();
  bool _isRecording = false; // Status nagrywania
  double _currentDecibels = 0.0; // Poziom decybeli
  String _decodedText = ""; // Dekodowany tekst w czasie rzeczywistym

  late NoiseMeter _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    _morseDecoder.openRecorder();
  }

  @override
  void dispose() {
    _stopNoiseMeter();
    _morseDecoder.closeRecorder();
    super.dispose();
  }

  void _startNoiseMeter() {
    _noiseSubscription = _noiseMeter.noise.listen((NoiseReading reading) {
      setState(() {
        _currentDecibels = reading.meanDecibel; // Aktualizacja poziomu decybeli
        _decodedText = _morseDecoder.decodedText; // Aktualizacja dekodowanego tekstu
      });
    });
  }

  void _stopNoiseMeter() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
  }

  // Funkcja do obsługi mikrofonu
  Future<void> _handleMicrophonePress() async {
    if (_isRecording) {
      // Zatrzymaj nagrywanie i NoiseMeter
      await _morseDecoder.stopRecorder();
      _stopNoiseMeter();
      setState(() {
        _isRecording = false;
        _currentDecibels = 0.0;
      });
    } else {
      // Rozpocznij nagrywanie i NoiseMeter
      await _morseDecoder.startRecorder();
      _startNoiseMeter();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Pierwszy kontener - nagłówek
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.transparent
              ),
              child: Center(
                child: Text(
                  "${_currentDecibels.toStringAsFixed(1)} dB",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Drugi kontener - wyświetlanie tekstu dekodowanego
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.colorScheme.onSurface.withOpacity(0.1)
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    _decodedText,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // Trzeci kontener - przycisk mikrofonu
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.transparent
              ),
              child: Center(
                child: IconButton(
                  onPressed: _handleMicrophonePress,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 50,
                    color: _isRecording ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                  tooltip: _isRecording
                      ? "Stop Recording"
                      : "Start Recording",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}