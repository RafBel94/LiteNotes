import 'package:flutter/material.dart';
import 'package:read_write_app/domain/entities/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> noteList = [];


  void addNote(Note note) {
    noteList.add(note);
    notifyListeners();
  }

  void removeNote(Note note) {
    noteList.remove(note);
    notifyListeners();
  }

  void updateNote(Note note) {
    for(Note n in noteList){
      if(n.id == note.id){
        n = note;
        notifyListeners();
      }
    }
  }
}