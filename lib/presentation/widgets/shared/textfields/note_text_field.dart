import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController noteTextController;
  final FocusNode noteTextFocusNode = FocusNode();
  final bool isEnabled;

  NoteTextField({super.key, required this.noteTextController, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: noteTextController,
      focusNode: noteTextFocusNode,
      enabled: isEnabled,
      maxLines: null,
      expands: true,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 43, 43, 42)), borderRadius: BorderRadius.circular(5)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 106, 106, 105)), borderRadius: BorderRadius.circular(5)
        ),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
