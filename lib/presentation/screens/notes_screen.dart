import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import '../widgets/note_button.dart';

class NotesScreen extends StatefulWidget {

  const NotesScreen({
    super.key,
  });

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {

  @override
  Widget build(BuildContext context) {

    NoteProvider noteProvider = context.watch<NoteProvider>();
    MultiselectProvider multiselectProvider = context.watch<MultiselectProvider>();

    List<Note> filteredNotes = noteProvider.filteredGroup == noteProvider.defaultGroup
        ? noteProvider.noteList
        : noteProvider.noteList
            .where((note) => note.group == noteProvider.filteredGroup)
            .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final Note note = filteredNotes[index];
            return NoteButton(
              note: note,
              isDeleted: false,
              isMultiSelectMode: multiselectProvider.isMultiSelectMode,
              isSelected: multiselectProvider.selectedNotes.contains(note),
              onLongPress: () {
                multiselectProvider.toggleMultiSelectMode();
              },
              onSelected: () {
                multiselectProvider.toggleSelection(note);
              },
              );
        },
      ),
    );
  }
}
