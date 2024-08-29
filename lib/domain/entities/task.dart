import 'package:uuid/uuid.dart';

class Task {
 String id;
 String text;
 DateTime creationDate;

 Task({required this.id, required this.text, required this.creationDate});

 factory Task.create({required String text}){
  return Task(
    id: const Uuid().v4(),
    text: text,
    creationDate: DateTime.now()
  );
 }

 factory Task.fromJson(Map<String, dynamic> json){
  return Task(
    id: json['id'],
    text: json['text'],
    creationDate: DateTime.parse(json['creationDate'])
  );
 }

 Map<String, dynamic> toJson(){
  return {
    'id': id,
    'text': text,
    'creationDate': creationDate.toIso8601String()
  };
 }
}