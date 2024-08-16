import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [                
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
          _NoteButton(),
        ],
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(25, 158, 158, 158))),
      onPressed: () {
    
      },
      child: const Text('Chore', style: TextStyle(fontSize: 40, color: Colors.white),)
      );
  }
}