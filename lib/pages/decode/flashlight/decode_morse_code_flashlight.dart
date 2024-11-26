import 'package:camera/camera.dart';
import 'package:morse_code/pages/morse_code_text.dart';
import '../../encode/flashlight/morse_code_flashlight_transmitter.dart';

enum BrightnessLevel {
  light,
  dark
}

class DecodeMorseCodeFlashlight {
  // acceptable upper error in ms in flashlight morse detection
  static double upperThreshold = 100;

  // acceptable lower error in ms in flashlight morse detection
  static double lowerThreshold = 100;

  // when pixel is considered to be flashlight (0-255)
  static double lightIntensity = 200;

  final _stopwatch = Stopwatch();

  bool isRunning = false;

  BrightnessLevel brightnessLevel = BrightnessLevel.dark;

  String _morseCode = "";

  get morseCode {
    return _morseCode;
  }

  get decodedText {
    return MorseCodeText.decode(_morseCode);
  }

  void run() {
    _stopwatch.start();
    isRunning = true;
  }

  void stop() {
    _stopwatch.stop();
    isRunning = false;
  }

  void reset() {
    _morseCode = "";
    _stopwatch.reset();
  }

  void processCameraImage(
      int averageBrightness,
      CameraImage image
      ) {

    if(!_stopwatch.isRunning) {
      throw Exception("Firstly call 'run' method");
    }

    if (averageBrightness < lightIntensity && brightnessLevel == BrightnessLevel.light) {
      int offsetNextDot = _stopwatch.elapsedMilliseconds - MorseCodeFlashlightTransmitter.dotTimeInMilliseconds;

      if (offsetNextDot <= upperThreshold || offsetNextDot.abs() <= lowerThreshold) {
        _morseCode += ".";
      } else {
        _morseCode += "-";
      }

      brightnessLevel = BrightnessLevel.dark;
      _stopwatch.reset();

    } else if (averageBrightness >= lightIntensity && brightnessLevel == BrightnessLevel.dark) {
      int offsetNextChar = _stopwatch.elapsedMilliseconds - MorseCodeFlashlightTransmitter.timeGapBetweenChars;

      int offsetNextWord = _stopwatch.elapsedMilliseconds - MorseCodeFlashlightTransmitter.timeGapBetweenWords;

      if(offsetNextWord >= 0 || offsetNextWord.abs() <= lowerThreshold) {
        _morseCode += "     ";
      } else if (offsetNextChar >= 0 || offsetNextChar.abs() <= lowerThreshold) {
        _morseCode += " ";
      }

      brightnessLevel = BrightnessLevel.light;

      _stopwatch.reset();
    }
  }
}