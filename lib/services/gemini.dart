// services/gemini_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class GeminiService {
  final String apiKey;
  final String visionEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  final String textEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  GeminiService({required this.apiKey});


  Future<String> analyzeImage(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      final fileSize = await imageFile.length();
      if (fileSize > 4 * 1024 * 1024) {
        throw Exception('Image file too large. Maximum size is 4MB');
      }

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = _getMimeType(imageFile.path);

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': 'Provide a concise summary of the image that mentions the elements/objects of image ,the sentiment analysis of image(vibe, mood, happy, sad , expressions, emotions), the aesthetic of image( vintage, old, modern, hitech, etc). give raw text without any extra symbols'
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

      final response = await http.post(
        Uri.parse('$visionEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to analyze image: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> getSong(String prompt) async{
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt + "recommend me 3 songs on the baiss of this (give just three songs nothing else"
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      final response = await http.post(
        Uri.parse('$textEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> getCaptions(String prompt) async{
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt + "Apply analysis and suggest 2 one liner captions"
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      final response = await http.post(
        Uri.parse('$textEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> getVibe(String prompt) async{
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt + "(in the beginning write hey looks like you got or something like that) Apply analysis and summarise it in 2 sentences"
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      final response = await http.post(
        Uri.parse('$textEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> getHashtags(String prompt) async{
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt + "Apply analysis and suggest popular hashtags (only give me hashtag and nothing other than that)"
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      final response = await http.post(
        Uri.parse('$textEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> getTextResponse(String prompt) async {
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': "Remember you are my chat bot keep that in mind and keep your messages limited in that way and more like a chat bot but never show that i have explicitly told you to do so "+prompt
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 4096,
        }
      };

      final response = await http.post(
        Uri.parse('$textEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return _extractResponse(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      rethrow;
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

  String _extractResponse(Map<String, dynamic> response) {
    try {
      return response['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      throw Exception('Invalid API response format');
    }
  }
}