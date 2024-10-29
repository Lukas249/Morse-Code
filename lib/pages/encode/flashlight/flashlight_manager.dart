import 'package:torch_light/torch_light.dart';

abstract class FlashlightManagerAbstract {
  Future<void> turnOnFlashlight();

  Future<void> turnOffFlashlight();

  Future<bool> isFlashlightAvailable();
}

class FlashlightManager implements FlashlightManagerAbstract {
  @override
  Future<bool> isFlashlightAvailable() async {
    return await TorchLight.isTorchAvailable();
  }

  @override
  Future<void> turnOffFlashlight() async {
    await TorchLight.disableTorch();
  }

  @override
  Future<void> turnOnFlashlight() async {
    await TorchLight.enableTorch();
  }

}