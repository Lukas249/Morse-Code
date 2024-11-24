import 'package:audioplayers/audioplayers.dart';

abstract class SoundManagerAbstract{
  Future<void> turnOnSound();
  Future<void> turnOffSound();
}

class SoundManager implements SoundManagerAbstract {
  final player = AudioPlayer();
 // String source = "beep.mp3";
  @override
  Future<void> turnOnSound() async{
    await player.play(AssetSource("beep.mp3"));
  }
  @override
  Future<void> turnOffSound() async {
    await player.stop();
  }
}