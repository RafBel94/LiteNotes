import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/domain/entities/group.dart';
import 'package:simple_notes/domain/entities/note.dart';
import 'package:simple_notes/presentation/screens/providers/group_provider.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> noteList = [];
  Group defaultGroup = Group.create(name: 'none', color: const Color.fromARGB(255, 103, 103, 103));
  Group? filteredGroup;

  NoteProvider();

  Future<void> initialize(GroupProvider groupProvider) async {
    filteredGroup = defaultGroup;
    await loadNotes(groupProvider);
  }

  Future<void> loadNotes(GroupProvider groupProvider) async {
    noteList = await readJson('notes_data.json');

    for (Note note in noteList) {
      if (note.group != null) {
        note.group = groupProvider.groupList
            .firstWhere((group) => group.id == note.group!.id, orElse: () => defaultGroup);
      }
    }

    notifyListeners();
  }

  void updateFilteredGroup(Group? group) {
    filteredGroup = group ?? defaultGroup;
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
    // Find the index of the note with same id as the parameter note
    int index = noteList.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      noteList[index] = note;
      saveNoteList(noteList);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateNoteGroups(Group group) {
    for(Note n in noteList) {
      if(n.group == group){
        n.group = defaultGroup;
      }
    }
    notifyListeners();
  }

  void sortListAlphabetically({required bool descendent}) {
    if(descendent) {
      // Ascendent ASCII value
      noteList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else {
      // Descendent ASCII value
      noteList.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }

    notifyListeners();
  }

  void sortListByModifiedDate({required bool recentFirst}) {
    if(recentFirst) {
      noteList.sort((a,b) => b.modifiedDate!.compareTo(a.modifiedDate!));
    } else {
      noteList.sort((a,b) => a.modifiedDate!.compareTo(b.modifiedDate!));
    }

    notifyListeners();
  }

  // METHODS RELATED TO READ/SAVE OF DATA LOCALLY

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