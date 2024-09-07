import 'package:flutter/material.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/domain/entities/task.dart';
import 'package:simple_notes/presentation/screens/providers/note_provider.dart';
import 'package:simple_notes/presentation/screens/providers/recicle_bin_provider.dart';
import 'package:simple_notes/presentation/screens/providers/task_provider.dart';

class MultiselectProvider extends ChangeNotifier {
  List<Note> selectedNotes = [];
  List<Task> selectedTasks = [];
  bool isNotesMultiSelectMode = false;
  bool isTasksMultiSelectMode = false;


  void toggleNotesMultiSelectMode() {
    isNotesMultiSelectMode = !isNotesMultiSelectMode;
    selectedNotes.clear();
    notifyListeners();
  }

  void toggleTasksMultiSelectMode() {
    isTasksMultiSelectMode = !isTasksMultiSelectMode;
    selectedTasks.clear();
    notifyListeners();
  }

  // Adds or removes note from selected notes list depending of it being already in the list or not
  void toggleNoteSelection(Note note) {
    if (selectedNotes.contains(note)) {
      selectedNotes.remove(note);
    } else {
      selectedNotes.add(note);
    }

    notifyListeners();
  }

  void toggleTaskSelection(Task task) {
    if(selectedTasks.contains(task)){
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }

    notifyListeners();
  }

  // Deletes all selected notes
  void deleteSelectedNotes(NoteProvider noteProvider, RecicleBinProvider recicleBinProvider) {
    recicleBinProvider.addNotes(selectedNotes);
    noteProvider.removeNotes(selectedNotes);
    toggleNotesMultiSelectMode();
  }

  // Deletes all selected tasks
  void deleteSelectedTasks(TaskProvider taskProvider, RecicleBinProvider recicleBinProvider) {
    recicleBinProvider.addTasks(selectedTasks);
    taskProvider.removeTasks(selectedTasks);
    toggleTasksMultiSelectMode();
  }
}