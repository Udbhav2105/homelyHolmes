import 'package:flutter/material.dart';
import 'package:homely_holmes/services/app_color.dart';

class InputField extends StatelessWidget {
  final String inputText;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.inputText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: AppColor.secondaryColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.secondaryColor,
            width: 0,
          ),
        ),
        labelText: inputText,
        labelStyle: const TextStyle(
          color: AppColor.secondaryColor,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColor.secondaryColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            // Handle the right arrow action
            print("Right arrow pressed");
          },
          icon: const Icon(Icons.arrow_forward, color: AppColor.secondaryColor), // Correctly wrapped in Icon widget
        ),
      ),
    );
  }
}
