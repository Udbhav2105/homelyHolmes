import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class ImageAnalyzer {
  final String apiKey;
  final String apiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  ImageAnalyzer(this.apiKey);

  Future<String> analyzeImage(String imagePath) async {
    try {
      // Read and encode image file
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': 'Describe this image in detail'
              },
              {
                'inline_data': {
                  'mime_type': _getMimeType(imagePath),
                  'data': base64Image
                }
              }
            ]
          }
        ]
      };

      // Make API request
      final response = await http.post(
        Uri.parse('$apiEndpoint?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return _extractDescription(data);
      } else {
        throw Exception('API request failed with status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      return 'Error analyzing image: $e';
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
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  String _extractDescription(Map<String, dynamic> response) {
    try {
      return response['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      return 'Unable to extract description from response';
    }
  }
}

class ImageAnalyzerCLI {
  final ImageAnalyzer analyzer;

  ImageAnalyzerCLI(this.analyzer);

  Future<void> start() async {
    print('Welcome to Image Analyzer CLI!');

    while (true) {
      print('\nOptions:');
      print('1. Analyze an image');
      print('2. Exit');
      print('\nEnter your choice (1-2):');

      final choice = stdin.readLineSync()?.trim();

      switch (choice) {
        case '1':
          await _handleImageAnalysis();
          break;
        case '2':
          print('Goodbye!');
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  Future<void> _handleImageAnalysis() async {
    print('\nEnter the path to your image file:');
    final imagePath = stdin.readLineSync()?.trim();

    if (imagePath == null || imagePath.isEmpty) {
      print('Invalid path provided.');
      return;
    }

    print('\nAnalyzing image...');
    final description = await analyzer.analyzeImage(imagePath);
    print('\nImage Analysis Result:');
    print('--------------------');
    print(description);
    print('--------------------');
  }
}

void main() async {
  // Replace with your actual API key
  const apiKey = 'AIzaSyAdoC69uK73kJMGzIdCBFniY0nMzbgh5Zo'
  ;

  final analyzer = ImageAnalyzer(apiKey);
  final cli = ImageAnalyzerCLI(analyzer);

  await cli.start();
}