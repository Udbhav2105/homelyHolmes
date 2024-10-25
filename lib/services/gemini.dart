
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class GeminiService {
  final String apiKey;
  final String apiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  GeminiService({required this.apiKey});

  Future<String> analyzeImage(File imageFile) async {
    try {
      // Verify file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      // Check file size (Gemini has a 4MB limit)
      final fileSize = await imageFile.length();
      if (fileSize > 4 * 1024 * 1024) {
        throw Exception('Image file too large. Maximum size is 4MB');
      }

      // Read and encode image
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = _getMimeType(imageFile.path);

      // Prepare request
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': 'Please describe this image in detail. What do you see?'
              },
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      // Make request
      final response = await http.post(
        Uri.parse('$apiEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractDescription(jsonDecode(response.body));
      } else {
        throw Exception('Failed to analyze image: ${response.body}');
      }
    } catch (e) {
      rethrow; // Let the UI handle the error
    }
  }

  String _getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        throw Exception('Unsupported image format: $extension');
    }
  }

  String _extractDescription(Map<String, dynamic> response) {
    try {
      return response['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      throw Exception('Invalid API response format');
    }
  }
}