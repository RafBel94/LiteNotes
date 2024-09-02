import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController titleController;
  final FocusNode? titleFocusNode;
  final bool isEnabled;

  const TitleTextField({super.key, required this.titleController, this.titleFocusNode, required this.isEnabled});

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: titleController,
      focusNode: titleFocusNode ?? FocusNode(),
      enabled: isEnabled,
      style: const TextStyle(fontSize: 22),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 43, 43, 42)), borderRadius: BorderRadius.circular(5)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 106, 106, 105)), borderRadius: BorderRadius.circular(5)
        ),
        hintText: 'Title...',
        hintStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 101, 101, 101))
      ),
      onTapOutside: (event) {
        titleFocusNode?.unfocus();
      },
    );
  }
}
