import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera.dart';
import 'upload.dart';
import 'help.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFirstText = true;
  bool _isPressed = false;

  String get _currentMessage => _showFirstText
      ? "Hi I am Koala Lapo,\nyour Trash Sorting Assistant"
      : "I will help you to make\nthe world better and cleaner";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAFFDD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -50),
                          child: Image.asset('assets/images/text_bubble.png'),
                        ),
                        Positioned(
                          top: 90,
                          left: 20,
                          right: 20,
                          child: Text(
                            _currentMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Transform.translate(
                      offset: const Offset(0, -190),
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() => _isPressed = true);
                        },
                        onTapUp: (_) {
                          setState(() {
                            _isPressed = false;
                            _showFirstText = !_showFirstText;
                          });
                        },
                        onTapCancel: () {
                          setState(() => _isPressed = false);
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 120),
                          scale: _isPressed ? 0.9 : 1.0,
                          child: Image.asset('assets/images/lapo.png'),
                        ),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -210),
                      child: Column(
                        children: [
                          _buildButton(
                            context,
                            "Scan",
                            Icons.camera_alt,
                            CameraScreen(camera: widget.cameras[0]),
                          ),
                          _buildButton(
                            context,
                            "Upload",
                            Icons.file_upload,
                            UploadScreen(),
                          ),
                          _buildButton(
                            context,
                            "Help",
                            Icons.help_outline,
                            const HelpScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              },
              icon: Icon(icon, color: Colors.white),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                minimumSize: const Size(50, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            child: Image.asset(
              'assets/images/leaves.png',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
