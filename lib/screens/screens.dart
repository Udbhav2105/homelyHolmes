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

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f4f2),
      appBar: AppBar(
        title: const Text('Media Access Demo'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: _images.isEmpty ? 100 :
                  (_images.length <= 3 ? 220 :
                  _images.length <= 6 ? 400 : 500),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    children: [
                      InputField(
                        inputText: "enter your desired theme",
                        controller: inp,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ImageGrid(
                          images: _images,
                          onRemove: _removeImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Click Me")
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MediaBottomBar(onPickImage: _pickImage),
    );
  }
}
