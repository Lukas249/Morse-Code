abstract class VibrationManagerAbstract {
  Future<void> vibrate({int duration, int amplitude});

  Future<bool> hasCustomVibrationsSupport();

  Future<bool> hasVibrator();

  Future<void> cancel();
}

class VibrationManager implements VibrationManagerAbstract {
  @override
  Future<void> cancel() {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  Future<bool> hasCustomVibrationsSupport() {
    // TODO: implement hasCustomVibrationsSupport
    throw UnimplementedError();
  }

  @override
  Future<bool> hasVibrator() {
    // TODO: implement hasVibrator
    throw UnimplementedError();
  }

  @override
  Future<void> vibrate({int? duration, int? amplitude}) {
    // TODO: implement vibrate
    throw UnimplementedError();
  }

}
