import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xFFCAFFDD),
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xFFCAFFDD),
              body: Center(child: Text("❌ Camera not available")),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trash Sorting Assistant',
          theme: ThemeData(primarySwatch: Colors.green),
          home: HomeScreen(cameras: snapshot.data!),
        );
      },
    );
  }
}