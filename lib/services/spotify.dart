
// const String apiKey = 'xC6POVBZouDmKsaPm8ddZR1PyYVqtfWY';
// const String externalUserId = '671b32f1478aa20e0cca4b81';
//
// Future<String> createChatSessionAndSubmitQuery(String prompt) async {
//   // Create Chat Session
//   final createSessionResponse = await http.post(
//     Uri.parse('https://api.on-demand.io/chat/v1/sessions'),
//     headers: {
//       'apikey': apiKey,
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'pluginIds': [],
//       'externalUserId': externalUserId,
//     }),
//   );
//
//   print('Status Code: ${createSessionResponse.statusCode}');
//   print('Response Body: ${createSessionResponse.body}');
//
//   if (createSessionResponse.statusCode == 200) {
//     final sessionData = jsonDecode(createSessionResponse.body);
//     final sessionId = sessionData['data']['id'];
//
//     // Submit Query
//     final submitQueryResponse = await http.post(
//       Uri.parse('https://api.on-demand.io/chat/v1/sessions/$sessionId/query'),
//       headers: {
//         'apikey': apiKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'endpointId': 'predefined-openai-gpt4o',
//         'query': 'suggest me 3 songs based on this' + prompt,
//         'pluginIds': ['plugin-1718189536'],
//         'responseMode': 'sync',
//       }),
//     );
//
//     if (submitQueryResponse.statusCode == 200) {
//      return  submitQueryResponse.body;
//     } else {
//       print('Failed to submit query: ${submitQueryResponse.statusCode}');
//     }
//   } else {
//     print('Failed to create chat session: ${createSessionResponse.statusCode}');
//   }
// }
//
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatAPI {
  static const String _apiKey = 'xC6POVBZouDmKsaPm8ddZR1PyYVqtfWY';
  static const String _externalUserId = '671b32f1478aa20e0cca4b81';

  Future<String> createChatSessionAndSubmitQuery(String prompt) async {
    final createSessionResponse = await http.post(
      Uri.parse('https://api.on-demand.io/chat/v1/sessions'),
      headers: {
        'apikey': _apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pluginIds': [],
        'externalUserId': _externalUserId,
      }),
    );

    print('Status Code: ${createSessionResponse.statusCode}');
    print('Response Body: ${createSessionResponse.body}');

    if (createSessionResponse.statusCode == 200) {
      final sessionData = jsonDecode(createSessionResponse.body);
      final sessionId = sessionData['data']['id'];

      final submitQueryResponse = await http.post(
        Uri.parse('https://api.on-demand.io/chat/v1/sessions/$sessionId/query'),
        headers: {
          'apikey': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'endpointId': 'predefined-openai-gpt4o',
          'query': 'suggest me 3 songs based on this$prompt',
          'pluginIds': ['plugin-1713962163','plugin-1718189536' ],
          'responseMode': 'sync',
        }),
      );

      if (submitQueryResponse.statusCode == 200) {
        return submitQueryResponse.body;
      } else {
        // Handle unsuccessful query submission
        print('Failed to submit query: ${submitQueryResponse.statusCode}');
        return 'Error: Failed to submit query. Status code: ${submitQueryResponse.statusCode}';
      }
    } else {
      print('Failed to create chat session: ${createSessionResponse.statusCode}');
      return 'Error: Failed to create chat session. Status code: ${createSessionResponse.statusCode}';
    }
  }
}
