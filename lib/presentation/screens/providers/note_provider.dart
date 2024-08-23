import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_write_app/domain/entities/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> noteList = [];

  NoteProvider() {
    _loadNotes();
  }

  // Método privado para cargar las notas desde el archivo JSON
  Future<void> _loadNotes() async {
    noteList = await readJson('notes_data.json');
    notifyListeners();
  }


  void addNote(Note note) {
    noteList.add(note);
    saveNoteList(noteList);
    notifyListeners();
  }

  void removeNote(Note note) {
    noteList.remove(note);
    saveNoteList(noteList);
    notifyListeners();
  }

  void updateNote(Note note) {
    for(Note n in noteList){
      if(n.id == note.id){
        n = note;
        saveNoteList(noteList);

        // Wait to all operations to finish before notify listeners
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });

      break;
      }
    }
  }

  String listToJson(List<Note> noteList) {
    List<Map<String, dynamic>> mapList = noteList.map((note) => note.toJson()).toList();
    String jsonString = jsonEncode(mapList);
    return jsonString;
  }

  Future<void> saveJson(String jsonContent, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(jsonContent);
  }

  Future<void> saveNoteList(List<Note> noteList) async {
    String jsonString = listToJson(noteList);
    await saveJson(jsonString, 'notes_data.json');
  }

  Future<List<Note>> readJson(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (await file.exists()) {
      String jsonContent = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(jsonContent);
      return jsonList.map((json) => Note.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}