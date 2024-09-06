import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/domain/entities/task.dart';

class RecicleBinProvider extends ChangeNotifier {
  List<Note> noteList = [];
  List<Task> taskList = [];

  RecicleBinProvider() {
    loadDeletedObjects();
  }

  // Notes

  void addNote(Note note) {
    note.deletedDate = DateTime.now();
    noteList.add(note);
    saveNoteList();
    notifyListeners();
  }

  void addNotes(List<Note> notes) {
    for(Note note in notes) {
      note.deletedDate = DateTime.now();
      noteList.add(note);
    }
    saveNoteList();
    notifyListeners();
  }

  void removeNote(Note note) {
    note.deletedDate = null;
    noteList.remove(note);
    saveNoteList();
    notifyListeners();
  }

  void removeNotes(List<Note> notes) {
    for(Note note in notes) {
      noteList.remove(note);
    }
    saveNoteList();
    notifyListeners();
  }

  // Tasks

  void addTask(Task task) {
    task.deletedDate = DateTime.now();
    taskList.add(task);
    saveTaskList();
    notifyListeners();
  }

  void addTasks(List<Task> tasks) {
    for(Task task in tasks) {
      task.deletedDate = DateTime.now();
      taskList.add(task);
    }
    saveTaskList();
    notifyListeners();
  }

  void removeTask(Task task) {
    task.deletedDate = null;
    taskList.remove(task);
    saveTaskList();
    notifyListeners();
  }

  void removeTasks(List<Task> tasks) {
    for(Task task in tasks) {
      taskList.remove(task);
    }
    saveTaskList();
    notifyListeners();
  }

  // Sort

  void sortByDeleteDate({required bool recentFirst, required String type}) {
    if(type == 'task'){
      if(recentFirst) {
        taskList.sort((a,b) => b.deletedDate!.compareTo(a.deletedDate!));
      } else {
        taskList.sort((a,b) => a.deletedDate!.compareTo(b.deletedDate!));
      }
    } else if (type == 'note'){
      if(recentFirst) {
        noteList.sort((a,b) => b.deletedDate!.compareTo(a.deletedDate!));
      } else {
        noteList.sort((a,b) => a.deletedDate!.compareTo(b.deletedDate!));
      }
    }

    notifyListeners();
  }

  // Delete old notes and tasks

  void deleteOldNotes() {
    final now = DateTime.now();
    noteList.removeWhere((note) => 
      now.difference(note.deletedDate!).inDays > 30
    );
    saveNoteList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void deleteOldTasks() {
    final now = DateTime.now();
    taskList.removeWhere((task) => 
      now.difference(task.deletedDate!).inDays > 30
    );
    saveTaskList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }


  // METHODS RELATED TO READ/SAVE DATA LOCALLY

  Future<void> loadDeletedObjects() async {
    // Read JSON data
    List<Map<String, dynamic>> notesData = await readJson('deleted_notes_data.json');
    List<Map<String, dynamic>> tasksData = await readJson('deleted_tasks_data.json');

    // Load Notes
    noteList = notesData.map((json) => Note.fromJson(json)).toList();

    // Load Tasks
    taskList = tasksData.map((json) => Task.fromJson(json)).toList();

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> readJson(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (await file.exists()) {
      String jsonContent = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(jsonContent));
    } else {
      return [];
    }
  }

  Future<void> saveNoteList() async {
    String jsonString = jsonEncode(noteList.map((note) => note.toJson()).toList());
    await saveJson(jsonString, 'deleted_notes_data.json');
  }

  Future<void> saveTaskList() async {
    String jsonString = jsonEncode(taskList.map((task) => task.toJson()).toList());
    await saveJson(jsonString, 'deleted_tasks_data.json');
  }

  Future<void> saveJson(String jsonContent, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(jsonContent);
  }
}
