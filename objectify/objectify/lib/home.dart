import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late ObjectDetector _objectDetector;
  List<DetectedObject> _objects = [];
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeObjectDetector();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    try {
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _initializeObjectDetector() {
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
  }

  Future<void> _detectObjects() async {
    if (!_controller.value.isInitialized || _isDetecting) {
      return;
    }
    _isDetecting = true;

    try {
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);

      // Perform object detection
      final List<DetectedObject> objects =
      await _objectDetector.processImage(inputImage);
      setState(() {
        _objects = objects;
      });
    } catch (e) {
      print('Error during object detection: $e');
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Object Recognition'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Recognition'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller),
          ),
          ElevatedButton(
            onPressed: _detectObjects,
            child: const Text('Detect Objects'),
          ),
          Expanded(
            child: _objects.isEmpty
                ? const Center(
              child: Text('No objects detected'),
            )
                : ListView.builder(
              itemCount: _objects.length,
              itemBuilder: (context, index) {
                final object = _objects[index];
                final label = object.labels.isNotEmpty
                    ? object.labels[0].text
                    : 'No label';
                final confidence = object.labels.isNotEmpty
                    ? object.labels[0].confidence.toStringAsFixed(2)
                    : 'N/A';

                return ListTile(
                  title: Text(label),
                  subtitle: Text('Confidence: $confidence'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}