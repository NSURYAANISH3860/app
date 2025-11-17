import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  static const _storageKey = 'todos_v1';
  final List<Todo> _items = [];
  List<Todo> get items => List.unmodifiable(_items);

  TodoProvider() {
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_storageKey) ?? [];
    _items.clear();
    _items.addAll(raw.map((e) => Todo.fromJson(e)));
    notifyListeners();
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    final raw = _items.map((t) => t.toJson()).toList();
    await sp.setStringList(_storageKey, raw);
  }

  Future<void> add(String title, {String? description, DateTime? dueDate}) async {
    final id = Uuid().v4();
    final t = Todo(id: id, title: title, description: description, dueDate: dueDate);
    _items.insert(0, t);
    await _save();
    notifyListeners();
  }

  Future<void> update(String id, {String? title, String? description, DateTime? dueDate}) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final old = _items[idx];
    _items[idx] = Todo(
      id: old.id,
      title: title ?? old.title,
      description: description ?? old.description,
      done: old.done,
      dueDate: dueDate ?? old.dueDate,
    );
    await _save();
    notifyListeners();
  }

  Future<void> toggleDone(String id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    _items[idx].done = !_items[idx].done;
    await _save();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((e) => e.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> clearCompleted() async {
    _items.removeWhere((e) => e.done);
    await _save();
    notifyListeners();
  }
}
