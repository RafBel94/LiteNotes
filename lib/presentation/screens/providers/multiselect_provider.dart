import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';

class MultiselectProvider extends ChangeNotifier {
  List<Note> selectedNotes = [];
  bool isMultiSelectMode = false;





  // Toggles multi select mode. If its activated, deactivates it and viceversa.
  // Always clears the selected notes list
  void toggleMultiSelectMode() {
      isMultiSelectMode = !isMultiSelectMode;
      selectedNotes.clear();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Adds or removes note from selected notes list depending of it being already in the list or not
  void toggleSelection(Note note) {
      if (selectedNotes.contains(note)) {
        selectedNotes.remove(note);
      } else {
        selectedNotes.add(note);
      }

      notifyListeners();
  }

  // Deletes all selected notes
  void deleteSelectedNotes(NoteProvider noteProvider, RecicleBinProvider recicleBinProvider) {
    recicleBinProvider.addNotes(selectedNotes);
    noteProvider.removeNotes(selectedNotes);
    toggleMultiSelectMode();
  }
}