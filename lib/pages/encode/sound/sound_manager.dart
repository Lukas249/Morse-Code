import 'package:audioplayers/audioplayers.dart';

abstract class SoundManagerAbstract{
  Future<void> play();
  Future<void> stop();
}

class SoundManager implements SoundManagerAbstract {
  AudioPlayer player;

  SoundManager(this.player);

  @override
  Future<void> play() async {
    await player.resume();
  }

  @override
  Future<void> stop() async {
    await player.stop();
  }
}
