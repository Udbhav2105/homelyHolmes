// import 'package:flutter/material.dart';
// import 'package:homely_holmes/components/input_field.dart';
// import 'package:homely_holmes/components/media_bottom_bar.dart';
// import 'package:homely_holmes/services/media_service.dart';
// import 'package:homely_holmes/components/image_grid.dart';
// import 'package:homely_holmes/services/permission_services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class Message {
//   final String? text;
//   final File? image;
//   final bool isImage;
//   Message({this.text, this.image, this.isImage = false});
// }
//
// class MediaAccessPage extends StatefulWidget {
//   const MediaAccessPage({Key? key}) : super(key: key);
//
//   @override
//   _MediaAccessPageState createState() => _MediaAccessPageState();
// }
//
// class _MediaAccessPageState extends State<MediaAccessPage> {
//   final TextEditingController inp = TextEditingController();
//   final List<File> _images = [];
//   final List<Message> _messages = [];
//   final MediaService _mediaService = MediaService();
//   final PermissionService _permissionService = PermissionService();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _permissionService.requestPermissions(context);
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final File? image = await _mediaService.pickImage(source);
//       if (image != null) {
//         setState(() {
//           _images.add(image);
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
//
//   void _sendMessage() {
//     if (inp.text.trim().isNotEmpty) {
//       setState(() {
//         _messages.add(Message(text: inp.text));
//         inp.clear();
//       });
//     }
//
//     if (_images.isNotEmpty) {
//       setState(() {
//         for (var image in _images) {
//           _messages.add(Message(image: image, isImage: true));
//         }
//         _images.clear();
//       });
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFf6f4f2),
//       appBar: AppBar(
//         title: const Text('Media Access Demo'),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Column(
//         children: [
//           // Messages area
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.8,
//                     ),
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: message.isImage
//                         ? Image.file(
//                       message.image!,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     )
//                         : Text(
//                       message.text!,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Bottom section with images grid and input
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   offset: const Offset(0, -2),
//                   blurRadius: 4,
//                   color: Colors.black.withOpacity(0.1),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Selected images grid
//                 if (_images.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     constraints: BoxConstraints(
//                       maxHeight: _images.length <= 3 ? 220 : 400,
//                     ),
//                     child: ImageGrid(
//                       images: _images,
//                       onRemove: (index) => setState(() => _images.removeAt(index)),
//                     ),
//                   ),
//                 // Input field and send button
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: InputField(
//                           inputText: "Type a message...",
//                           controller: inp,
//                           onSubmit: _sendMessage,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                     ],
//                   ),
//                 ),
//                 // Media bottom bar
//                 MediaBottomBar(onPickImage: _pickImage),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     inp.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// media_access_page.dart

import 'package:flutter/material.dart';
import 'package:homely_holmes/components/input_field.dart';
import 'package:homely_holmes/components/media_bottom_bar.dart';
import 'package:homely_holmes/components/image_grid.dart';
import 'package:homely_holmes/services/permission_services.dart';
import 'package:homely_holmes/services/media_service.dart';
import 'package:homely_holmes/services/gemini.dart';  // We'll create this
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Message {
  final String? text;
  final File? image;
  final bool isImage;
  final bool isResponse;

  Message({
    this.text,
    this.image,
    this.isImage = false,
    this.isResponse = false,
  });
}

class MediaAccessPage extends StatefulWidget {
  final String geminiApiKey;

  const MediaAccessPage({
    Key? key,
    required this.geminiApiKey,
  }) : super(key: key);

  @override
  _MediaAccessPageState createState() => _MediaAccessPageState();
}

class _MediaAccessPageState extends State<MediaAccessPage> {
  final TextEditingController inp = TextEditingController();
  final List<File> _images = [];
  final List<Message> _messages = [];
  final MediaService _mediaService = MediaService();
  final PermissionService _permissionService = PermissionService();
  final ScrollController _scrollController = ScrollController();
  late final GeminiService _geminiService;

  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _permissionService.requestPermissions(context);
    _geminiService = GeminiService(apiKey: widget.geminiApiKey);
  }

  // Add the missing _pickImage method
  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await _mediaService.pickImage(source);
      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  // Add the missing _showError method
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _sendMessage() async {
    try {
      // Handle text message
      if (inp.text.trim().isNotEmpty) {
        final userMessage = inp.text.trim();

        // Add user message to the list first
        setState(() {
          _messages.add(Message(
            text: userMessage,
            isResponse: false,
          ));
          inp.clear();
        });

        try {
          // Get response from Gemini
          final res = await _geminiService.getTextResponse(userMessage);
          setState(() {
            _messages.add(Message(
              text: res,
              isResponse: true,
            ));
          });
        } catch (e) {
          print('Error getting Gemini response: $e');
          _showError('Failed to get AI response');
        }
      }

      // Handle images
      if (_images.isNotEmpty) {
        setState(() => _isAnalyzing = true);

        for (var image in _images) {
          // Add image message
          setState(() {
            _messages.add(Message(image: image, isImage: true, isResponse: false));
          });

          try {
            // Get analysis from Gemini
            final analysis = await _geminiService.analyzeImage(image);
            final tags = await _geminiService.getHashtags(analysis);
            final vibe = await _geminiService.getVibe(analysis);
            final captions = await _geminiService.getCaptions(analysis);

            // Add response messages
            setState(() {
              _messages.addAll([
                Message(
                  text: vibe,
                  isResponse: true,
                ),
                Message(
                  text: "Here's some Hashtags that you might find interesting\n$tags",
                  isResponse: true,
                ),
                Message(
                  text: "Here are some captions for you\n$captions",
                  isResponse: true,
                ),
              ]);
            });
          } catch (e) {
            _showError('Error analyzing image: $e');
            setState(() {
              _messages.add(Message(
                text: 'Failed to analyze image. Please try again.',
                isResponse: true,
              ));
            });
          }
        }

        // Clear images after processing
        setState(() {
          _images.clear();
          _isAnalyzing = false;
        });
      }

      _scrollToBottom();
    } catch (e) {
      setState(() => _isAnalyzing = false);
      _showError('Error sending message: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f4f2),
      appBar: AppBar(
        title: const Text('AI Image Chat'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          if (_isAnalyzing)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          BottomInputSection(
            images: _images,
            inputController: inp,
            onRemoveImage: (index) => setState(() => _images.removeAt(index)),
            onSendMessage: _sendMessage,
            onPickImage: _pickImage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    inp.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
// Extracted widgets for better organization
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isResponse
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isResponse
              ? Colors.grey[300]
              : Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: message.isImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            message.image!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        )
            : Text(
          message.text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class BottomInputSection extends StatelessWidget {
  final List<File> images;
  final TextEditingController inputController;
  final Function(int) onRemoveImage;
  final VoidCallback onSendMessage;
  final Function(ImageSource) onPickImage;

  const BottomInputSection({
    Key? key,
    required this.images,
    required this.inputController,
    required this.onRemoveImage,
    required this.onSendMessage,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (images.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxHeight: images.length <= 3 ? 220 : 400,
              ),
              child: ImageGrid(
                images: images,
                onRemove: onRemoveImage,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InputField(
                    inputText: "Type a message...",
                    controller: inputController,
                    onSubmit: onSendMessage,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          MediaBottomBar(onPickImage: onPickImage),
        ],
      ),
    );
  }
}