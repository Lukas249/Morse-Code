import '../transmit_morse_code.dart';
import 'vibration_manager.dart';

class MorseCodeVibrationTransmitter extends TransmitMorseCode {

  static int dotTimeInMilliseconds = 300;

  static int dashTimeInMilliseconds = dotTimeInMilliseconds * 3;

  static int timeGapBetweenDotsAndDashes = dotTimeInMilliseconds + 400;

  static int timeGapBetweenChars = dotTimeInMilliseconds * 3;

  static int timeGapBetweenWords = dotTimeInMilliseconds * 7;

  final VibrationManager vib;

  MorseCodeVibrationTransmitter(this.vib);

  @override
  Future<void> transmitDot() async {
    await vib.vibrate(duration: dotTimeInMilliseconds, amplitude: 255);
  }

  @override
  Future<void> transmitDash() async {
    await vib.vibrate(duration: dashTimeInMilliseconds, amplitude: 255);
  }

  @override
  Future<void> waitTimeGapBetweenDotsAndDashes() async {
    await Future.delayed(Duration(milliseconds: timeGapBetweenDotsAndDashes));
  }

  @override
  Future<void> waitTimeGapBetweenChars() async {
    await Future.delayed(Duration(milliseconds: timeGapBetweenChars));
  }

  @override
  Future<void> waitTimeGapBetweenWords() async {
    await Future.delayed(Duration(milliseconds: timeGapBetweenWords));
  }
}