

import 'package:flutter/material.dart';
import 'package:read_write_app/domain/entities/note.dart';
import 'package:read_write_app/presentation/screens/providers/note_provider.dart';

class NewNoteScreen extends StatelessWidget {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();
  final NoteProvider noteProvider;

  NewNoteScreen({super.key, required this.noteProvider});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {

            addNote(titleController.text, noteTextController.text, noteProvider);

            Navigator.pop(context);
          }
        ),
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: const Text('New Note', style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            _TitleTextField(titleController: titleController),


            const Divider(
              color: Color.fromARGB(203, 249, 212, 102),
              indent: 5,
              endIndent: 5,
            ),

            Expanded(child: _NoteTextField(noteTextController: noteTextController)),
          ],
        ),
      ),

      floatingActionButton: IconButton(
        icon: Icon(Icons.delete),
        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(164, 255, 193, 7))),
        iconSize: 50,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
  
 void addNote(String title, String text, NoteProvider noteProvider) {
    String trimmedTitle = title.trim();
    String trimmedText = text.trim();

    if (trimmedText.isNotEmpty) {
      if (trimmedTitle.isEmpty) {
        trimmedTitle = 'No Title';
      }

      Note note = Note.create(title: trimmedTitle, text: text);
      noteProvider.addNote(note);
      
    }else if (trimmedText.isEmpty && trimmedTitle.isNotEmpty) {
      Note note = Note.create(title: trimmedTitle, text: text);
      noteProvider.addNote(note);
    }
  }
}


class _TitleTextField extends StatelessWidget {

  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController titleController;

  _TitleTextField({required this.titleController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      style: const TextStyle(fontSize: 22),
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

  final FocusNode noteTextFocusNode = FocusNode();
  final TextEditingController noteTextController;

  _NoteTextField({required this.noteTextController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: noteTextController,
      focusNode: noteTextFocusNode,
      maxLines: null,
      expands: true,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(fontSize: 18),
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

