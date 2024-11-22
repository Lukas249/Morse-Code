import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../morse_code_text.dart';
import 'package:noise_meter/noise_meter.dart';
import '../../encode/flashlight/morse_code_flashlight_transmitter.dart';

enum SoundLevel { quiet, noisy }

class DecodeMorseCodeSound {
  // Statusy nagrywania i poziomu decybeli
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  SoundLevel soundLevel = SoundLevel.quiet;

  // Progi decybeli
  final double quietThreshold = 50.0; // Granica ciszy
  final double noiseThreshold = 75.0; // Granica hałasu

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
    _stopwatch.start();
    // Rozpoczęcie monitorowania poziomu decybeli
    _startNoiseMeter();
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

    _noiseSubscription = _noiseMeter!.noise.listen((NoiseReading reading) {
      _analyzeDecibels(reading.meanDecibel);
    });
  }

  // Zatrzymanie monitorowania poziomu decybeli
  void _stopNoiseMeter() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
  }

  // Analiza decybeli i dodanie odpowiednich znaków do kodu Morse'a
  void _analyzeDecibels(double db) {
    double currentDecibels = db;

    // Przejście do stanu hałasu
    if (currentDecibels >= noiseThreshold && soundLevel == SoundLevel.quiet) {
      int elapsed = _stopwatch.elapsedMilliseconds;

      if (elapsed <= MorseCodeFlashlightTransmitter.dotTimeInMilliseconds) {
        _morseCode += "."; // Krótki sygnał
      } else {
        _morseCode += "-"; // Długi sygnał
      }

      soundLevel = SoundLevel.noisy;
      _stopwatch.reset();
    }
    // Przejście do stanu ciszy
    else if (currentDecibels < quietThreshold && soundLevel == SoundLevel.noisy) {
      int elapsed = _stopwatch.elapsedMilliseconds;

      if (elapsed >= MorseCodeFlashlightTransmitter.timeGapBetweenWords) {
        _morseCode += "     "; // Przerwa między słowami
      } else if (elapsed >= MorseCodeFlashlightTransmitter.timeGapBetweenChars) {
        _morseCode += " "; // Przerwa między znakami
      }

      soundLevel = SoundLevel.quiet;
      _stopwatch.reset();
    }
  }

}