import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/ai_service.dart';
import 'package:flutter/foundation.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  final AIService _aiService = AIService();
  String _result = "Tap Lapo to scan";
  bool _isProcessing = false;

  // For animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _aiService.loadModel();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    await _controller.initialize();
    if (mounted) setState(() {});
  }

Future<void> _captureAndClassify() async {
  if (!_controller.value.isInitialized || _isProcessing) return;

  setState(() {
    _isProcessing = true;
    _result = "Scanning...";
  });

  try {
    final photo = await _controller.takePicture();

    if (kIsWeb) {
      final bytes = await photo.readAsBytes();
      final result = await _aiService.classifyWebImage(bytes);
      setState(() => _result = result);
    } else {
      final file = File(photo.path);
      final result = await _aiService.classifyImage(file);
      setState(() => _result = result);
    }

  } catch (e) {
    setState(() {
      _result = "Error: $e";
    });
  } finally {
    setState(() {
      _isProcessing = false;
    });
  }
}

  @override
  void dispose() {
    _controller.dispose();
    _aiService.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAFFDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: !_controller.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                alignment: Alignment.center,
                children: [
                  // 📷 Camera feed
                  Positioned.fill(child: CameraPreview(_controller)),

                  // 📋 Result Text (above Lapo)
                  Positioned(
                    bottom: 160,
                    left: 20,
                    right: 20,
                    child: Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        backgroundColor: Colors.white70,
                      ),
                    ),
                  ),

                  // 🐨 Lapo as scanning button
                  Positioned(
                    bottom: 40,
                    child: GestureDetector(
                      onTap: _captureAndClassify,
                      child: ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        )),
                        child: Image.asset(
                          'assets/images/lapo.png',
                          width: 120,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
