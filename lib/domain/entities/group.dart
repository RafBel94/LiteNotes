import 'dart:ui';

import 'package:uuid/uuid.dart';

class Group {
  String id;
  String name;
  Color color;

  Group({required this.id, required this.name, required this.color});

  factory Group.create({
    required String name,
    required Color color,
  }) {
    return Group(
      id: const Uuid().v4(),
      name: name,
      color: color
    );
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      color: Color(json['color'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value, // Convert to ARGB
    };
  }
}
