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
    await vib.vibrate(duration: 900, amplitude: 255);
  }

  @override
  Future<void> transmitDot() async {
    await vib.vibrate(duration: 300, amplitude: 255);
  }

  @override
  Future<void> waitTimeGapBetweenChars() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> waitTimeGapBetweenDotsAndDashes() async {
    await Future.delayed(const Duration(milliseconds: 900));
  }

  @override
  Future<void> waitTimeGapBetweenWords() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }

}