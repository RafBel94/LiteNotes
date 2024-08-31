import 'package:simple_notes/domain/entities/task_check.dart';
import 'package:uuid/uuid.dart';

class Task {
 String id;
 String title;
 List<TaskCheck> checkList;
 DateTime creationDate;

 Task({required this.id, required this.title, required this.checkList, required this.creationDate});

 factory Task.create({required String title, required List<TaskCheck> checkList}){
  return Task(
    id: const Uuid().v4(),
    title: title,
    checkList: checkList,
    creationDate: DateTime.now()
  );
 }

 factory Task.fromJson(Map<String, dynamic> json){
  return Task(
    id: json['id'],
    title: json['title'],
    checkList: (json['checkList'] as List).map((taskCheckJson) => TaskCheck.fromJson(taskCheckJson)).toList(),
    creationDate: DateTime.parse(json['creationDate'])
  );
 }

 Map<String, dynamic> toJson(){
  return {
    'id': id,
    'title': title,
    'checkList': checkList.map((taskCheck) => taskCheck.toJson()).toList(),
    'creationDate': creationDate.toIso8601String()
  };
 }
}