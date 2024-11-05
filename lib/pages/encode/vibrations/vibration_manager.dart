import 'package:vibration/vibration.dart';

abstract class VibrationManagerAbstract {
  Future<void> vibrate({int duration, int amplitude});

  Future<bool> hasCustomVibrationsSupport();

  Future<bool> hasVibrator();

  Future<void> cancel();
}

class VibrationManager implements VibrationManagerAbstract {

  @override
  Future<void> vibrate({int duration = 500, int amplitude = -1}) async {
    await Vibration.vibrate(duration: duration, amplitude: amplitude);
  }

  @override
  Future<bool> hasCustomVibrationsSupport() async {
    return await Vibration.hasCustomVibrationsSupport() ?? false;
  }

  @override
  Future<bool> hasVibrator() async {
    return await Vibration.hasVibrator() ?? false;
  }

  @override
  Future<void> cancel() async {
    await Vibration.cancel();
  }
}
