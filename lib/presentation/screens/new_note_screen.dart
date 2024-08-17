import 'package:flutter/material.dart';

class NewNoteScreen extends StatelessWidget {
  const NewNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        centerTitle: true,
        title: Text('New Note'),
      ),
      body: Column(
        children: [
          TextField(
            
          )
        ],
      )
    );
  }
}