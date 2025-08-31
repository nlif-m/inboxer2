import 'package:flutter/material.dart';
import 'todo_model.dart';

export 'todo_model.dart';
export 'todo_service.dart';
export 'todo_service_inbox_file.dart';

abstract class TodoService extends ChangeNotifier {
  ValueNotifier<List<Todo>> todos();
  Future<void> add(Todo todo);
  Future<bool> delete(Todo todo);
  Future<void> init();
  Future<void> update();
  Future<bool> updateTodo(Todo old, Todo new_);
}
