import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_write_app/domain/entities/note.dart';
import 'package:read_write_app/presentation/screens/providers/note_provider.dart';
import 'package:read_write_app/presentation/screens/user_note_screen.dart';

class NotesScreen extends StatelessWidget {

  final NoteProvider noteProvider;
  
  NotesScreen({
    super.key, required this.noteProvider,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GridView.builder(
        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: noteProvider.noteList.length,
        itemBuilder: (context, index) {
          final Note note = noteProvider.noteList[index];

          return _NoteButton(title: note.title, note: note, noteProvider: noteProvider,);
        },
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {

  final String title;
  final Note note;
  final NoteProvider noteProvider;

  const _NoteButton({required this.title, required this.note, required this.noteProvider});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
        backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(25, 158, 158, 158))
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserNoteScreen(note: note, noteProvider: noteProvider,)));
      },
      child: Text(title, style: const TextStyle(fontSize: 30, color: Colors.white),)
      );
  }
}