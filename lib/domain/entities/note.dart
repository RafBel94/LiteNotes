import 'package:simple_notes/domain/entities/group.dart';
import 'package:uuid/uuid.dart';

class Note {
  String id;
  String title;
  String text;
  Group? group;
  DateTime? creationDate;
  DateTime? modifiedDate;
  DateTime? deletedDate;

  Note({required this.id, required this.title, required this.text, this.creationDate, this.modifiedDate, this.deletedDate, this.group});

  factory Note.create({
    required String title,
    required String text,
    Group? group,
    DateTime? creationDate,
    DateTime? modifiedDate,
    DateTime? deletedDate
  }) {
    return Note(
      id: const Uuid().v4(),
      title: title,
      text: text,
      group: group,
      creationDate: creationDate ?? DateTime.now(),
      modifiedDate: modifiedDate ?? DateTime.now(),
      deletedDate: deletedDate
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      creationDate: DateTime.parse(json['creationDate']),
      modifiedDate: DateTime.parse(json['modifiedDate']),
      deletedDate: json['deletedDate'] != null ? DateTime.parse(json['deletedDate']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'note',
      'id': id,
      'title': title,
      'text': text,
      'group': group?.toJson(),
      'creationDate': creationDate?.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'deletedDate': deletedDate?.toIso8601String()
    };
  }
}