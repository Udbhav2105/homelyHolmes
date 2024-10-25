import 'package:flutter/material.dart';
import 'dart:io';

class ImageGrid extends StatelessWidget {
  final List<File> images;

  const ImageGrid({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.file(
          images[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}
