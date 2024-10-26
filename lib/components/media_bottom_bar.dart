import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaBottomBar extends StatelessWidget {
  final Function(ImageSource) onPickImage;

  const MediaBottomBar({Key? key, required this.onPickImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => onPickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF493525), // Background color
                foregroundColor: Color(0xFFF6E8DA), // Text/icon color
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // More rounded corners
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => onPickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF493525), // Background color
                foregroundColor: Color(0xFFF6E8DA), // Text/icon color
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // More rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
