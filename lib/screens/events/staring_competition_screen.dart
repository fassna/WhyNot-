import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class StaringCompetitionScreen extends StatefulWidget {
  const StaringCompetitionScreen({super.key});

  @override
  State<StaringCompetitionScreen> createState() => _StaringCompetitionScreenState();
}

class _StaringCompetitionScreenState extends State<StaringCompetitionScreen> {
  bool _isStaring = false;
  int _secondsSurvived = 0;
  int _blinksCount = 0;
  Timer? _timer;
  String _message = 'Tap "START STARING" and gaze blankly into the camera.';

  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isCameraInitialized = false;
  bool _isProcessingImage = false;
  final CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      setState(() {
        _message = 'Eye detection is not supported on Web. Play manually!';
      });
      return;
    }

    var status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _message = 'Camera permission required for eye detection.';
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == _direction,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      final options = FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      );
      _faceDetector = FaceDetector(options: options);

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  void _startStaring() {
    final provider = context.read<OlympicsProvider>();
    _timer?.cancel();
    setState(() {
      _isStaring = true;
      _secondsSurvived = 0;
      _blinksCount = 0;
      _message = '👀 STARE ACTIVATED. DO NOT BLINK.';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _secondsSurvived++;
          if (kIsWeb && _secondsSurvived % 4 == 0) _blinksCount++; // Fake blinks for web
        });

        if (_secondsSurvived == 15) {
          provider.awardMedal('staring', MedalType.bronze);
        } else if (_secondsSurvived == 30) {
          provider.awardMedal('staring', MedalType.silver);
        } else if (_secondsSurvived == 45) {
          provider.awardMedal('staring', MedalType.gold);
        }
      }
    });

    if (_isCameraInitialized && _cameraController != null && !kIsWeb) {
      _cameraController!.startImageStream(_processCameraImage);
    }
  }

  void _stopStaring() {
    final provider = context.read<OlympicsProvider>();
    provider.logAttempt('staring');
    _timer?.cancel();
    if (_isCameraInitialized && _cameraController != null && !kIsWeb) {
      try {
        if (_cameraController!.value.isStreamingImages) {
          _cameraController!.stopImageStream();
        }
      } catch (e) {
        debugPrint("Error stopping stream: $e");
      }
    }
    setState(() {
      _isStaring = false;
      if (!_message.contains('You blinked')) {
        _message = '🎉 Congratulations! You stared at absolutely nothing for $_secondsSurvived seconds.';
      }
    });
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessingImage || _faceDetector == null || !_isStaring) return;
    _isProcessingImage = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);

      for (final face in faces) {
        if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
          final leftOpen = face.leftEyeOpenProbability!;
          final rightOpen = face.rightEyeOpenProbability!;

          if (leftOpen < 0.2 || rightOpen < 0.2) {
            // Blink detected!
            if (mounted) {
              setState(() {
                _blinksCount++;
                _message = '😭 You blinked! Game over. Survived $_secondsSurvived seconds.';
              });
              _stopStaring();
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Face detection error: $e");
    } finally {
      _isProcessingImage = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👀 Blank Screen Staring Marathon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: 'Survived staring at void: $_secondsSurvived seconds.',
            ),
            const SizedBox(height: 16),
            NeoCard(
              backgroundColor: AppTheme.cardBg,
              padding: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'WORLD RECORD:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.pinkAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🏆 37.4 sec', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Void Box / Camera Preview
                  GestureDetector(
                    onTap: _isStaring ? _stopStaring : _startStaring,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                        color: _isStaring ? Colors.black : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor, width: 3),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isCameraInitialized && _cameraController != null && !_isStaring)
                            SizedBox.expand(
                              child: CameraPreview(_cameraController!),
                            ),
                          if (_isCameraInitialized && _cameraController != null && _isStaring)
                            Opacity(
                              opacity: 0.2, // dim the camera while staring
                              child: SizedBox.expand(
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isStaring ? '👁️  👁️' : (_isCameraInitialized ? '' : '😴'),
                                  style: const TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _isStaring ? 'TIME SURVIVED: $_secondsSurvived SEC' : 'BLANK SCREEN VOID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: _isStaring ? Colors.white : AppTheme.darkText,
                                    shadows: _isStaring ? [const Shadow(color: Colors.black, blurRadius: 10)] : null,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isStaring ? '(TAP SCREEN TO GIVE UP)' : '(TAP TO START STARING)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isStaring ? Colors.white60 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.pinkAccent),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _stat('Time Survived', '$_secondsSurvived sec'),
                      _stat('Blinks Tracked', '$_blinksCount'),
                      _stat('Purpose', '0%'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    );
  }
}
