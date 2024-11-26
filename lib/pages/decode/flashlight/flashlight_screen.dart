import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:morse_code/pages/decode/flashlight/decode_morse_code_flashlight.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() {
    return FlashlightScreenState();
  }
}

class FlashlightScreenState extends State<FlashlightScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[100],
      child: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FlashlightCameraScreen()),
                );
              },
              child: const Text("Open camera")),
        ],
      ),
    );
  }
}

class FlashlightCameraScreen extends StatefulWidget {
  const FlashlightCameraScreen({super.key});

  @override
  State<FlashlightCameraScreen> createState() {
    return FlashlightCameraScreenState();
  }
}

class FlashlightCameraScreenState extends State<FlashlightCameraScreen> {
  late final List<CameraDescription> _cameras;

  // camera controller
  late CameraController controller;
  bool controllerInitialized = false;

  // camera stream
  bool isRecording = false;
  int currentCameraIndex = 0;
  bool _isImageProcessing = false;

  // camera scale
  double _currentCameraScale = 1.0;
  double _baseCameraScale = 1.0;

  // camera zoom
  late double _maxAvailableCameraZoom;
  late double _minAvailableCameraZoom;

  // pointers on screen
  int _pointers = 0;

  // brightness inside circle
  int _averageBrightness = 0;

  // stopwatch
  final Stopwatch _imageProcessStopwatch = Stopwatch();

  // circle at center
  final double _circleRadius = 20;

  // circle scale
  double _currentCircleScale = 1.0;

  // decoder
  DecodeMorseCodeFlashlight decodeMorseCodeFlashlight =
      DecodeMorseCodeFlashlight();

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      _cameras = cameras;
    }).then((_) async {
      try {
        await initCameraController(currentCameraIndex);
        _imageProcessStopwatch.start();
        controller.startImageStream(imageProcess);
        controllerInitialized = true;
      } catch (e) {
        _navigateBack();
      }

      setState(() {});
    });
  }

  Future<void> initCameraController(int cameraIndex) async {
    controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();

    _maxAvailableCameraZoom = await controller.getMaxZoomLevel();
    _minAvailableCameraZoom = await controller.getMinZoomLevel();

    _currentCameraScale = 1.0;
    _baseCameraScale = 1.0;

    _currentCircleScale = 1.0;
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();

    if (controllerInitialized) {
      controller.stopImageStream().then((_) {
        controller.dispose();
      });
    } else {
      controller.dispose();
    }
  }

  void onStartRecording() {
    decodeMorseCodeFlashlight.run();
    decodeMorseCodeFlashlight.reset();
    setState(() {
      isRecording = true;
    });
  }

  void onStopRecording() {
    decodeMorseCodeFlashlight.stop();
    setState(() {
      isRecording = false;
    });
  }

  void imageProcess(CameraImage image) async {
    if (_isImageProcessing || _imageProcessStopwatch.elapsedMilliseconds < 50) {
      return;
    }

    _isImageProcessing = true;

    try {
      int averageBrightness =
          calculateAverageBrightnessInCircle(image, _circleRadius.toInt())
              .toInt();

      if (decodeMorseCodeFlashlight.isRunning) {
        decodeMorseCodeFlashlight.processCameraImage(averageBrightness, image);
      }

      setState(() {
        _averageBrightness = averageBrightness;
      });
    } finally {
      _isImageProcessing = false;
    }

    _imageProcessStopwatch.reset();
  }

  int getPixelBrightnessYUV420(CameraImage image, int x, int y) {
    Plane plane = image.planes[0];
    return plane.bytes[y * image.width + x];
  }

  double calculateAverageBrightnessInCircle(CameraImage image, int radius) {
    double brightnessSum = 0.0;
    int pixelCount = 0;

    int width = image.width;
    int height = image.height;

    // Get the center of the image
    int cx = width ~/ 2;
    int cy = height ~/ 2;

    for (int y = cy - radius; y <= cy + radius; y++) {
      for (int x = cx - radius; x <= cx + radius; x++) {
        // Calculate the distance from the center
        double distance = sqrt(pow(x - cx, 2) + pow(y - cy, 2));

        // If the pixel is inside the circle (distance <= radius), process it
        if (distance <= radius) {
          brightnessSum += getPixelBrightnessYUV420(image, x, y);
          pixelCount++;
        }
      }
    }

    // Calculate the average brightness, or return 0 if no pixels are inside the circle
    return pixelCount > 0 ? brightnessSum / pixelCount : 0.0;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseCameraScale = _currentCameraScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (_pointers != 2) {
      return;
    }

    double newCameraScale = (_baseCameraScale * details.scale)
        .clamp(_minAvailableCameraZoom, _maxAvailableCameraZoom);

    if ((newCameraScale - _currentCameraScale).abs() < 0.05 &&
        newCameraScale - _minAvailableCameraZoom >= 0.05 &&
        _maxAvailableCameraZoom - newCameraScale >= 0.05) return;

    _currentCameraScale = newCameraScale;

    await controller.setZoomLevel(_currentCameraScale);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: controllerInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Listener(
                      onPointerDown: (_) => _pointers++,
                      onPointerUp: (_) => _pointers--,
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: GestureDetector(
                          onScaleStart: _handleScaleStart,
                          onScaleUpdate: _handleScaleUpdate,
                          child: CameraPreview(
                            controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: _circleRadius * 2 * _currentCircleScale,
                      width: _circleRadius * 2 * _currentCircleScale,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.7)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          decodeMorseCodeFlashlight.decodedText.trim() != ""
                              ? Container(
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(maxHeight: 100),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SelectionArea(
                                      child: Text(
                                        decodeMorseCodeFlashlight.decodedText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Luminance",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      _averageBrightness.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ), //
                                  ],
                                ), // Left element which can change in size
                              ),
                              Flexible(
                                flex: 0,
                                child: isRecording
                                    ? StopRecordingButton(onStopRecording)
                                    : StartRecordingButton(onStartRecording),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Zoom",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      _currentCameraScale.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ), //
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

Widget StartRecordingButton(void Function() onStartRecording) {
  return Container(
    width: 60, // Width of the inner circle
    height: 60,
    child: TextButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.white), // White background
        shape: WidgetStateProperty.all<OutlinedBorder>(
          const CircleBorder(), // Circular button
        ),
      ),
      onPressed: onStartRecording,
      child: Container(
        width: 20, // Width of the inner circle
        height: 20, // Height of the inner circle
        decoration: const BoxDecoration(
          color: Colors.lightBlue, // Red color for the inner circle
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

Widget StopRecordingButton(void Function() onStopRecording) {
  return Container(
    width: 60, // Width of the inner circle
    height: 60,
    child: TextButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.white), // White background
        shape: WidgetStateProperty.all<OutlinedBorder>(
          const CircleBorder(), // Circular button
        ),
      ),
      onPressed: onStopRecording,
      child: Container(
        width: 20, // Width of the inner square
        height: 20, // Height of the inner square
        decoration: const BoxDecoration(
          color: Colors.lightBlue, // Red color for the inner circle
        ),
      ),
    ),
  );
}
