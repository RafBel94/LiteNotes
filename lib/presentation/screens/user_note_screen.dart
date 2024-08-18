
import 'package:flutter/material.dart';
import 'package:read_write_app/domain/entities/note.dart';
import 'package:read_write_app/presentation/screens/providers/note_provider.dart';

class UserNoteScreen extends StatelessWidget {

  final Note note;
  final TextEditingController titleController;
  final TextEditingController noteTextController;
  final NoteProvider noteProvider;

  UserNoteScreen({super.key, required this.noteProvider, required this.note})
      : titleController = TextEditingController(text: note.title),
        noteTextController = TextEditingController(text: note.text);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            String title = titleController.text;
            String text = noteTextController.text;

            note.title = title;
            note.text = text;

            noteProvider.updateNote(note);
            
            Navigator.pop(context);
          }
        ),
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: Text(note.title, style: const TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            _TitleTextField(titleController: titleController,),


            const Divider(
              color: Color.fromARGB(203, 249, 212, 102),
              indent: 5,
              endIndent: 5,
            ),

            Expanded(child: _NoteTextField(noteTextController: noteTextController,)),
          ],
        ),
      )
    );
  }
}


class _TitleTextField extends StatelessWidget {

  final TextEditingController titleController;
  final FocusNode titleFocusNode = FocusNode();

   _TitleTextField({required this.titleController});  // Aquí se inicializa el controlador con el título

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

  final TextEditingController noteTextController;
  final FocusNode noteTextFocusNode = FocusNode();

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

