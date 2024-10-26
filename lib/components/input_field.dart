import 'package:flutter/material.dart';
import 'package:homely_holmes/services/app_color.dart';

class InputField extends StatelessWidget {
  final String inputText;
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const InputField({
    super.key,
    required this.inputText,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: AppColor.secondaryColor,
      ),
      onSubmitted: (value) {
        onSubmit();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF6F4F2), // Change this to your desired background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // More rounded corners
          borderSide: const BorderSide(
            color: Color(0xFF493525), // Border color
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF493525), // Border color when enabled
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF493525), // Border color when focused
            width: 2.0,
          ),
        ),
        labelText: inputText,
        labelStyle: const TextStyle(
          color: Color(0xFF493525), // Label text color
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF493525), // Floating label color
        ),
        suffixIcon: IconButton(
          onPressed: onSubmit,
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF493525)), // Correctly wrapped in Icon widget
        ),
      ),
    );
  }
}
