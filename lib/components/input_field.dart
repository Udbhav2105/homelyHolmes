import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String inputText;
  final TextEditingController controller;

  const InputField({super.key, required this.inputText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black54,
      ),
    );
  }
}
