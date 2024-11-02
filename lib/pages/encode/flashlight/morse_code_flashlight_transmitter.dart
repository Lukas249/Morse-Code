import 'dart:math';

import '../transmit_morse_code.dart';
import 'flashlight_manager.dart';


//TODO: Check waitTimes  in use

class MorseCodeFlashlightTransmitter extends TransmitMorseCode {
  final FlashlightManager flashlightManager;


  MorseCodeFlashlightTransmitter(this.flashlightManager);
  @override
  Future<void> transmit(String morseCode) async {
    for (int i = 0; i < morseCode.length;i++)
    {
      String singleCharacter = morseCode[i];
      if (singleCharacter == '.')
        await transmitDot();

      else if (singleCharacter == '-')
        await transmitDash();

      else if (singleCharacter == ' ')
        await waitTimeGapBetweenWords();

      if (singleCharacter == '.' || singleCharacter =='-')
        await waitTimeGapBetweenDotsAndDashes();

    }

  }

  @override
  Future<void> transmitDash() async {
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: 600));
    await flashlightManager.turnOffFlashlight();
  }

  @override
  Future<void> transmitDot() async {
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: 200));
    await flashlightManager.turnOffFlashlight();

  }

  @override
  Future<void> waitTimeGapBetweenChars() async{
    await Future.delayed(Duration(milliseconds: 700));

  }

  @override
  Future<void> waitTimeGapBetweenDotsAndDashes() async{
    await Future.delayed(Duration(milliseconds: 300));
  }

  @override
  Future<void> waitTimeGapBetweenWords() async {

    await Future.delayed(Duration(milliseconds: 1400));

  }

}