abstract class FlashlightManagerAbstract {
  Future<void> turnOnFlashlight();

  Future<void> turnOffFlashlight();

  Future<bool> isFlashlightAvailable();
}

class FlashlightManager implements FlashlightManagerAbstract {
  @override
  Future<bool> isFlashlightAvailable() {
    // TODO: implement isFlashlightAvailable
    throw UnimplementedError();
  }

  @override
  Future<void> turnOffFlashlight() {
    // TODO: implement turnOffFlashlight
    throw UnimplementedError();
  }

  @override
  Future<void> turnOnFlashlight() {
    // TODO: implement turnOnFlashlight
    throw UnimplementedError();
  }

}