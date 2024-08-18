import 'package:flutter/material.dart';
import 'package:read_write_app/domain/entities/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> noteList = [Note(id: '1', title: 'Titulo', text: 'Texto')];


  void addNote(Note note) {
    noteList.add(note);
    notifyListeners();
  }
}