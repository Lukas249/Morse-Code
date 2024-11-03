import '../transmit_morse_code.dart';
import 'vibration_manager.dart';

class MorseCodeVibrationTransmitter extends TransmitMorseCode {
  final VibrationManager vib;

  MorseCodeVibrationTransmitter(this.vib);
  @override
  Future<void> transmit(String morseCode) async {
    for (int i = 0; i < morseCode.length;i++)
    {
      String singleCharacter = morseCode[i];
      if (singleCharacter == '.') {
        await transmitDot();
      }
      else if (singleCharacter == '-') {
        await transmitDash();
      }
      else if (singleCharacter == ' ') {
        await waitTimeGapBetweenWords();
      }
      if (singleCharacter == '.' || singleCharacter =='-') {
        await waitTimeGapBetweenDotsAndDashes();
      }

    }
  }

  @override
  Future<void> transmitDash() async {
    vib.vibrate(duration: 600, amplitude: 128);
  }

  @override
  Future<void> transmitDot() async {
    vib.vibrate(duration: 200, amplitude: 128);
  }

  @override
  Future<void> waitTimeGapBetweenChars() async {
    await Future.delayed(const Duration(milliseconds: 700));
  }

  @override
  Future<void> waitTimeGapBetweenDotsAndDashes() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> waitTimeGapBetweenWords() async {
    await Future.delayed(const Duration(milliseconds: 1400));
  }

}