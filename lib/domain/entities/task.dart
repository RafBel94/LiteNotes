import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:uuid/uuid.dart';

class Task {
 String id;
 String title;
 List<TaskCheck> checkList;
 DateTime creationDate;
 DateTime? deletedDate;

 Task({required this.id, required this.title, required this.checkList, required this.creationDate, this.deletedDate});

 factory Task.create({required String title, required List<TaskCheck> checkList, DateTime? deletedDate}){
  return Task(
    id: const Uuid().v4(),
    title: title,
    checkList: checkList,
    creationDate: DateTime.now(),
    deletedDate: deletedDate
  );
 }

 factory Task.fromJson(Map<String, dynamic> json){
  return Task(
    id: json['id'],
    title: json['title'],
    checkList: (json['checkList'] as List).map((taskCheckJson) => TaskCheck.fromJson(taskCheckJson)).toList(),
    creationDate: DateTime.parse(json['creationDate']),
    deletedDate: json['deletedDate'] != null ? DateTime.parse(json['deletedDate']) : null
  );
 }

 Map<String, dynamic> toJson(){
  return {
    'type': 'task',
    'id': id,
    'title': title,
    'checkList': checkList.map((taskCheck) => taskCheck.toJson()).toList(),
    'creationDate': creationDate.toIso8601String(),
    'deletedDate': deletedDate?.toIso8601String()
  };
 }
}