import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tflite/tflite.dart';
import 'package:image/image.dart';
import 'api_service.dart';

class AIService {
  Future<void> loadModel() async {
    if (kIsWeb) return;

    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print("✅ Model loaded successfully");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  Future<String> classifyImage(File image) async {
    if (kIsWeb) {
      throw UnsupportedError("This method doesn't support web. Use `classifyWebImage` instead.");
    }

    final output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (output == null || output.isEmpty) return "Unable to classify";

    final result = output.first;
    return "${result["label"]} (${(result["confidence"] * 100).toStringAsFixed(2)}%)";
  }

  Future<String> classifyWebImage(Uint8List imageBytes) async {
    try {
      final response = await ApiService.classifyWebImage(imageBytes);

      final label = response["label"];
      final confidence = (response["confidence"] * 100).toStringAsFixed(2);
      return "$label ($confidence%)";
    } catch (e) {
      return "Error: $e";
    }
  }

  void dispose() {
    if (!kIsWeb) {
      Tflite.close();
    }
  }
}
