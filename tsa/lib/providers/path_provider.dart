import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';


Future<File> saveImageTemporarily(Uint8List imageBytes) async {
  final directory = await getTemporaryDirectory();
  final filePath = "${directory.path}/captured_image.jpg";
  final file = File(filePath);

  await file.writeAsBytes(imageBytes);
  return file;
}
