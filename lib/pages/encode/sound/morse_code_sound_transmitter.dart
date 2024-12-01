import '../transmit_morse_code.dart';
import 'sound_manager.dart';

class MorseCodeSoundTransmitter extends TransmitMorseCode {

  static int dotTimeInMilliseconds = 300;

  static int dashTimeInMilliseconds = dotTimeInMilliseconds * 3;

  static int timeGapBetweenDotsAndDashes = dotTimeInMilliseconds;

  static int timeGapBetweenChars = dotTimeInMilliseconds * 3;

  static int timeGapBetweenWords = dotTimeInMilliseconds * 7;

  SoundManager soundManager;

  MorseCodeSoundTransmitter(this.soundManager);

  @override
  Future<void> transmitDot() async {
    await soundManager.play();
    await Future.delayed(Duration(milliseconds: dotTimeInMilliseconds));
    await soundManager.stop();
  }

  @override
  Future<void> transmitDash() async {
    await soundManager.play();
    await Future.delayed(Duration(milliseconds: dashTimeInMilliseconds));
    await soundManager.stop();
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