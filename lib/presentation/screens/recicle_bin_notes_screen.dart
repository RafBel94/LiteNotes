import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/multiselect_provider.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/widgets/dialogs/confirmation_dialog.dart';
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
  final MultiselectProvider multiselectProvider = context.watch<MultiselectProvider>();
  final NoteProvider noteProvider = context.read<NoteProvider>();
  final List<Note> deletedNotesList = binProvider.noteList;

  // Delete notes older than 30 days
  binProvider.deleteOldNotes();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          if(multiselectProvider.isMultiSelectMode){
            multiselectProvider.toggleMultiSelectMode();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 23, 23, 23),
        appBar: AppBar(
          actions: [
            if (multiselectProvider.isMultiSelectMode) 
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                multiselectProvider.toggleMultiSelectMode();
              },
            ),
      
            if (multiselectProvider.isMultiSelectMode) 
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteSelectedNotes(binProvider, multiselectProvider);
              },
            ),
      
            if (multiselectProvider.isMultiSelectMode) 
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                restoreSelectedNotes(multiselectProvider, noteProvider, binProvider);
              }
            ),
      
            const SortButton(isDeletedScreen: true, objectType: 'note',)
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
              isMultiSelectMode: multiselectProvider.isMultiSelectMode,
              isSelected: multiselectProvider.selectedNotes.contains(deletedNotesList[index]),
              onLongPress: () {
                multiselectProvider.toggleMultiSelectMode();
              },
              onSelected: () {
                multiselectProvider.toggleSelection(deletedNotesList[index]);
              },
            );
          },
         ),
        )
      ),
    );
  }
  
  void restoreSelectedNotes(MultiselectProvider multiselectProvider, NoteProvider noteProvider, RecicleBinProvider binProvider) {
    ConfirmationDialog(context: context, message: 'Do you want to restore all the selected notes?').showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        binProvider.removeNotes(multiselectProvider.selectedNotes);
        noteProvider.addNotes(multiselectProvider.selectedNotes);
      }
        multiselectProvider.toggleMultiSelectMode();
    });
  }
  
  void deleteSelectedNotes(RecicleBinProvider binProvider, MultiselectProvider multiselectProvider) {
    ConfirmationDialog(context: context, message: 'Do you want to permanently delete all the selected notes?').showConfirmationDialog(context).then((confirmation) {
      if (confirmation == true) {
        binProvider.removeNotes(multiselectProvider.selectedNotes);
      }
        multiselectProvider.toggleMultiSelectMode();
    });
  }
}