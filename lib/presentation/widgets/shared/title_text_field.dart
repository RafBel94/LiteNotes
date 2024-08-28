import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController titleController;
  final FocusNode titleFocusNode = FocusNode();

  TitleTextField({super.key, required this.titleController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      style: const TextStyle(fontSize: 22),
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: 'Title', hintStyle: const TextStyle(fontSize: 18)),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
