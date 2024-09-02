import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/widgets/note_button.dart';
import 'package:simple_notes/presentation/widgets/sort_button.dart';

class RecicleBinNotesScreen extends StatefulWidget {
  const RecicleBinNotesScreen({super.key});

  @override
  State<RecicleBinNotesScreen> createState() => _RecicleBinNotesScreenState();
}

class _RecicleBinNotesScreenState extends State<RecicleBinNotesScreen> {


  @override
  Widget build(BuildContext context) {

  final RecicleBinProvider binProvider = context.watch<RecicleBinProvider>();
  final List<Note> deletedNotesList = binProvider.noteList;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        actions: const [
          SortButton()
        ],
        backgroundColor: const Color.fromARGB(255, 254, 204, 54),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text('Deleted Notes', style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: deletedNotesList.length,
        itemBuilder: (context, index) {
          return NoteButton(note: deletedNotesList[index], isDeleted: true);
        },
       ),
      )
    );
  }
}