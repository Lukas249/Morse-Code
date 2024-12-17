import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../morse_code_text.dart';
import 'package:noise_meter/noise_meter.dart';
import '../../encode/flashlight/morse_code_flashlight_transmitter.dart';

class DecodeMorseCodeSound {
  // Statusy nagrywania i poziomu decybeli
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  int noiseDetect = 64;

  // Stopwatch do analizy czasu
  final Stopwatch _stopwatch = Stopwatch();

  // Dekodowany kod Morse'a
  String _morseCode = "";

  // Getter dla kodu Morse'a i tekstu
  String get morseCode => _morseCode;
  String get decodedText => MorseCodeText.decode(_morseCode);

  // FlutterSoundRecorder do nagrywania
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  // Konstruktor inicjalizujący NoiseMeter
  DecodeMorseCodeSound() {
    _noiseMeter = NoiseMeter();
  }

  // Pobranie ścieżki do tymczasowego pliku nagrania
  Future<String> _getTemporaryFilePath() async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/temp_recording.aac';
  }

  // Otwarcie sesji nagrywania
  Future<void> openRecorder() async {
    await _recorder.openRecorder();
  }

  // Zamknięcie sesji nagrywania
  Future<void> closeRecorder() async {
    await _recorder.closeRecorder();
    _noiseSubscription?.cancel();
  }

  // Rozpoczęcie nagrywania
  Future<void> startRecorder() async {
    final path = await _getTemporaryFilePath();

    // Żądanie dostępu do mikrofonu
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    // Rozpoczęcie nagrywania
    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );

    _isRecording = true;
    _startNoiseMeter();
    _stopwatch.start();
  }

  // Zatrzymanie nagrywania
  Future<void> stopRecorder() async {
    await _recorder.stopRecorder();
    _isRecording = false;
    _stopwatch.stop();
    _stopwatch.reset();

    // Zatrzymanie monitorowania poziomu decybeli
    _stopNoiseMeter();

    // Usunięcie tymczasowego pliku
    final file = File(await _getTemporaryFilePath());
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Rozpoczęcie monitorowania poziomu decybeli
  void _startNoiseMeter() {
    if (_noiseMeter == null) return;

    bool isSignalActive = false; // Czy sygnał jest obecnie aktywny
    int signalStartTime = 0; // Czas rozpoczęcia sygnału
    int silenceStartTime = 0; // Czas rozpoczęcia ciszy
    int margin = 40;

    _noiseSubscription = _noiseMeter!.noise.listen((NoiseReading reading) {
      final currentTime = _stopwatch.elapsedMilliseconds;

      if (reading.meanDecibel >= noiseDetect) {
        // Dźwięk przekroczył próg
        if (!isSignalActive) {
          // Rozpoczęcie nowego sygnału
          isSignalActive = true;
          signalStartTime = currentTime;

          // Analiza czasu ciszy
          if (silenceStartTime > 0) {
            int silenceDuration = currentTime - silenceStartTime;

            if (silenceDuration >= MorseCodeFlashlightTransmitter.timeGapBetweenWords - margin*3) {
              _morseCode += "    "; // Przerwa między słowami
            } else if (silenceDuration >= MorseCodeFlashlightTransmitter.timeGapBetweenChars - margin*7) {
              _morseCode += " "; // Przerwa między znakami
            }
            else
            {
              _morseCode += "";
            }
          }
        }
      } else {
        // Cisza
        if (isSignalActive) {
          // Zakończenie sygnału
          isSignalActive = false;
          int signalDuration = currentTime - signalStartTime;

          if (signalDuration <= MorseCodeFlashlightTransmitter.dotTimeInMilliseconds * 2) {
            _morseCode += "."; // Dodaj kropkę
          } else {
            _morseCode += "-"; // Dodaj kreskę
          }

          // Rozpoczęcie liczenia ciszy
          silenceStartTime = currentTime;
        }
      }
    });
  }

  // Zatrzymanie monitorowania poziomu decybeli
  void _stopNoiseMeter() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
  }
}
