import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
static const String _baseUrl = "http://192.168.0.37:5000";

  static Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    final uri = Uri.parse("$_baseUrl/predict");

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> classifyWebImage(Uint8List imageBytes) async {
    final uri = Uri.parse("$_baseUrl/predict");

    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'upload.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Web request failed: ${response.statusCode} ${response.body}');
    }
  }
}
