import '../transmit_morse_code.dart';
import 'flashlight_manager.dart';


//TODO: Check waitTimes  in use

class MorseCodeFlashlightTransmitter extends TransmitMorseCode {
  final FlashlightManager flashlightManager;


  MorseCodeFlashlightTransmitter(this.flashlightManager);
  @override
  Future<void> transmit(String morseCode) async {
    // TODO: implement transmit
    throw UnimplementedError();
  }

  @override
  Future<void> transmitDash() async {
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: 600)); // Długie włączenie
    await flashlightManager.turnOffFlashlight();
  }

  @override
  Future<void> transmitDot() async {
    await flashlightManager.turnOnFlashlight();
    await Future.delayed(Duration(milliseconds: 200)); // Krótkie włączenie
    await flashlightManager.turnOffFlashlight();

  }

  @override
  Future<void> waitTimeGapBetweenChars() async{
    await Future.delayed(Duration(milliseconds: 700));
    throw UnimplementedError();
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