import 'package:flutter/material.dart';
import 'package:homely_holmes/components/input_field.dart';
import 'package:homely_holmes/components/media_bottom_bar.dart';
import 'package:homely_holmes/services/media_service.dart';
import 'package:homely_holmes/components/image_grid.dart';
import 'package:homely_holmes/services/permission_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MediaAccessPage extends StatefulWidget {
  const MediaAccessPage({Key? key}) : super(key: key);

  @override
  _MediaAccessPageState createState() => _MediaAccessPageState();
}

class _MediaAccessPageState extends State<MediaAccessPage> {
  final TextEditingController inp = TextEditingController();
  final List<File> _images = [];
  final MediaService _mediaService = MediaService();
  final PermissionService _permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    _permissionService.requestPermissions(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await _mediaService.pickImage(source);
      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Access Demo'),
      ),
      // body: ImageGrid(images: _images),
      body: Column(
        children: [
          Expanded(
            child: ImageGrid(images: _images),
          ),
          InputField(inputText:"enter your desiered theme", controller: inp ),
          ElevatedButton(onPressed: () {}, child: const Text("Click Me")),
        ],
      ),
      bottomNavigationBar: MediaBottomBar(onPickImage: _pickImage),
    );
  }
}

// lib/services/permission_service.dart
