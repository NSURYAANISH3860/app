import 'dart:convert';

class Todo {
  String id;
  String title;
  String? description;
  bool done;
  DateTime? dueDate;
  Todo({
    required this.id,
    required this.title,
    this.description,
    this.done = false,
    this.dueDate,
  });

  factory Todo.fromMap(Map<String, dynamic> m) => Todo(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String?,
        done: m['done'] as bool? ?? false,
        dueDate: m['dueDate'] == null ? null : DateTime.parse(m['dueDate'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'done': done,
        'dueDate': dueDate?.toIso8601String(),
      };

  String toJson() => jsonEncode(toMap());
  factory Todo.fromJson(String s) => Todo.fromMap(jsonDecode(s));
}
