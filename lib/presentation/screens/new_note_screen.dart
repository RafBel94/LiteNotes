
import 'package:flutter/material.dart';

class NewNoteScreen extends StatelessWidget {
  NewNoteScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black,),
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: const Text('New Note', style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            _TitleTextField(),


            const Divider(
              color: Color.fromARGB(203, 249, 212, 102),
              indent: 5,
              endIndent: 5,
            ),

            Expanded(child: _NoteTextField()),
          ],
        ),
      )
    );
  }
}

class _TitleTextField extends StatelessWidget {

  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      style: TextStyle(fontSize: 22),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Title',
        hintStyle: const TextStyle(fontSize: 18)
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

class _NoteTextField extends StatelessWidget {

  final TextEditingController noteTextController = TextEditingController();
  final FocusNode noteTextFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: noteTextController,
      focusNode: noteTextFocusNode,
      maxLines: null,
      expands: true,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Text...',
        hintStyle: const TextStyle(fontSize: 18),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

