import '../sound/sound_manager.dart';
import '../transmit_morse_code.dart';
import 'flashlight_manager.dart';

class MorseCodeFlashlightTransmitter extends TransmitMorseCode {

  static int dotTimeInMilliseconds = 300;

  static int dashTimeInMilliseconds = dotTimeInMilliseconds * 3;

  static int timeGapBetweenDotsAndDashes = dotTimeInMilliseconds;

  static int timeGapBetweenChars = dotTimeInMilliseconds * 3;

  static int timeGapBetweenWords = dotTimeInMilliseconds * 7;

  late final FlashlightManager flashlightManager; // nadpisanie  menegera latarki i stworzenie instancji do transmisji
  late final SoundManager? soundManager;

  MorseCodeFlashlightTransmitter(this.flashlightManager, this.soundManager);

  @override
  Future<void> transmitDot() async {
    await soundManager?.play();
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: dotTimeInMilliseconds));
    await flashlightManager.turnOffFlashlight();
    await soundManager?.stop();
  }

  @override
  Future<void> transmitDash() async {
    await soundManager?.play();
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: dashTimeInMilliseconds));
    await flashlightManager.turnOffFlashlight();
    await soundManager?.stop();
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