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
  // TODO: Implement multirestoration and multidelete

  bool isMultiSelectMode = false;
  List<Note> selectedNotes = [];

  @override
  Widget build(BuildContext context) {

  final RecicleBinProvider binProvider = context.watch<RecicleBinProvider>();
  final List<Note> deletedNotesList = binProvider.noteList;

  // Delete notes older than 30 days
  binProvider.deleteOldNotes();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        actions: const [
          SortButton(isDeletedScreen: true, objectType: 'note',)
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
          return NoteButton(
            note: deletedNotesList[index],
            isDeleted: true,
            isMultiSelectMode: isMultiSelectMode,
            isSelected: selectedNotes.contains(deletedNotesList[index]),
            onLongPress: () {
              toggleMultiSelectMode();
            },
            onSelected: () {
              toggleSelection(deletedNotesList[index]);
            },
          );
        },
       ),
      )
    );
  }

  // Toggles multi select mode. If its activated, deactivates it and viceversa.
  // Always clears the selected notes list
  void toggleMultiSelectMode() {
    setState(() {
      isMultiSelectMode = !isMultiSelectMode;
      selectedNotes.clear();
    });
  }

  // Adds or removes note from selected notes list depending of it being already in the list or not
  void toggleSelection(Note note) {
    setState(() {
      if (selectedNotes.contains(note)) {
        selectedNotes.remove(note);
      } else {
        selectedNotes.add(note);
      }
    });
  }
}