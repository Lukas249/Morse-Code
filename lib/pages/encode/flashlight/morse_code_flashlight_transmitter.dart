import 'package:audioplayers/audioplayers.dart';

import '../transmit_morse_code.dart';
import 'flashlight_manager.dart';


//TODO: Check waitTimes  in use

class MorseCodeFlashlightTransmitter extends TransmitMorseCode {

  static int dotTimeInMilliseconds = 300;

  static int dashTimeInMilliseconds = dotTimeInMilliseconds * 3;

  static int timeGapBetweenDotsAndDashes = dotTimeInMilliseconds;

  static int timeGapBetweenChars = dotTimeInMilliseconds * 3;

  static int timeGapBetweenWords = dotTimeInMilliseconds * 7;

  final FlashlightManager flashlightManager; // nadpisanie  menegera latarki i stworzenie instancji do transmisji

  final AudioPlayer beepSoundForFlashlight = AudioPlayer(); //instancja audioplayer
  bool isBeepingon = true; //do zaimplementowania w ustawieniach mozliwosc wylaczenia

  MorseCodeFlashlightTransmitter(this.flashlightManager);

  @override
  Future<void> transmitDot() async {
    await flashlightManager.turnOnFlashlight();
    if(isBeepingon == true){
      await beepSoundForFlashlight.play(AssetSource('beep.mp3'));
    }
    await Future.delayed(Duration(milliseconds: dotTimeInMilliseconds));
    await beepSoundForFlashlight.stop();
    await flashlightManager.turnOffFlashlight();
  }

  @override
  Future<void> transmitDash() async {
    await flashlightManager.turnOnFlashlight();
    if (isBeepingon == true){
      await beepSoundForFlashlight.play(AssetSource('beep.mp3'));
    }
    await Future.delayed(Duration(milliseconds: dashTimeInMilliseconds));
    await beepSoundForFlashlight.stop();
    await flashlightManager.turnOffFlashlight();
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