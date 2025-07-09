import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/ai_service.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final AIService _aiService = AIService();
  File? _image;
  Uint8List? _webImage;
  String _result = "Choose an image from your device and I will advise you the type of trash";
  bool _modelLoaded = false;

@override
void initState() {
  super.initState();
  if (!kIsWeb) {
    _aiService.loadModel().then((_) {
      setState(() {
        _modelLoaded = true;
      });
    });
  } else {
    _modelLoaded = true;
  }
}

Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return;

  setState(() {
    _result = "Sending image to AI...";
  });

  try {
    if (kIsWeb) {
      Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _webImage = bytes;
        _image = null;
      });

      final prediction = await ApiService.classifyWebImage(bytes);
      setState(() {
        _result = "${prediction['label']}";
      });

    } else {
      File file = File(pickedFile.path);
      setState(() {
        _image = file;
        _webImage = null;
      });

      final prediction = await ApiService.classifyImage(file);
      setState(() {
        _result = "${prediction['label']} (${(prediction['confidence'] * 100).toStringAsFixed(2)}%)";
      });
    }
  } catch (e) {
    setState(() {
      _result = "Error: $e";
    });
  }
}

  @override
  void dispose() {
    _aiService.dispose();
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
  child: Stack(
    alignment: Alignment.center,
    children: [
      Positioned(
        top: -50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset("assets/images/text_bubble.png", width: 300),
Positioned(
  top: 110,
  child: SizedBox(
    width: 180,
    child: _result.contains("Choose")
        ? Text(
            _result,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        : RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: 'Looks like it is '),
                TextSpan(
                  text: _result,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
  ),
),
          ],
        ),
      ),
      Positioned(
        top: 170,
        child: Image.asset("assets/images/lapo.png", width: 180),
      ),
      Positioned(
        top: 290,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
              : _webImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(_webImage!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
        ),
      ),
      Positioned(
        top: 600,
        child: ElevatedButton.icon(
          onPressed: _modelLoaded ? _pickImage : null,
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload from device"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
