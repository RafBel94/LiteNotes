import 'package:uuid/uuid.dart';

class TaskCheck {
  String id;
  String text;
  bool done;

  TaskCheck({required this.id, required this.text, required this.done});

  factory TaskCheck.create(String text, bool done){
    return TaskCheck(
      id: const Uuid().v4(),
      text: text,
      done: done
    );
  }

  factory TaskCheck.fromJson(Map<String, dynamic> json) {
    return TaskCheck(
      id: json['id'],
      text: json['text'],
      done: json['done']
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'done': done
    };
  }
}