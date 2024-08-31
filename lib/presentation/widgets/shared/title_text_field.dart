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
      decoration: InputDecoration(
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
        FocusScope.of(context).unfocus();
      },
    );
  }
}
