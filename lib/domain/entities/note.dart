
import 'package:uuid/uuid.dart';

class Note {
  String id;
  String title;
  String text;

  Note({required this.id, required this.title, required this.text});

  factory Note.create({
    required String title,
    required String text,
  }) {
    return Note(
      id: const Uuid().v4(), // Genera un ID único usando UUID
      title: title,
      text: text,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json){
    return Note(
      id: json['id'],
      title: json['title'],
      text: json['text']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text
    };
  }
}