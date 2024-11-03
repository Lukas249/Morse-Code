import 'package:vibration/vibration.dart';

abstract class VibrationManagerAbstract {
  Future<void> vibrate({int duration, int amplitude});

  Future<bool?> hasCustomVibrationsSupport();

  Future<bool?> hasVibrator();

  Future<void> cancel();
}

class VibrationManager implements VibrationManagerAbstract {
  @override
  Future<void> cancel() async{
     await Vibration.cancel();
  }

  @override
  Future<bool?> hasCustomVibrationsSupport() async {
    return await Vibration.hasCustomVibrationsSupport();
  }

  @override
  Future<bool?> hasVibrator() async {
    return await Vibration.hasVibrator();
  }

  @override
  Future<void> vibrate({int? duration, int? amplitude}) async {
    await Vibration.vibrate();
  }

}
