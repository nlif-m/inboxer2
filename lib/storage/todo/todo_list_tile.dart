import 'package:inboxer2/main.dart';
import 'package:flutter/material.dart';

import 'package:inboxer2/storage/todo/todo.dart';
import 'package:inboxer2/storage/todo/todo_card_widget.dart';
import 'package:inboxer2/storage/todo/todo_delete_dialog.dart';
import 'package:inboxer2/storage/todo/todo_edit_dialog.dart';
import 'package:watch_it/watch_it.dart';

class TodoListTile extends StatelessWidget with WatchItMixin {
  final Todo todo;
  final bool hidden;
  TodoListTile({super.key, required this.todo, required this.hidden});

  @override
  Widget build(BuildContext context) {
    final todoStorage = getIt<TodoStorage>();
    return GestureDetector(
      onLongPress: () async {
        var isDelete = await showDialog(
            context: context,
            builder: (context) {
              return TodoDeleteDialog(todo: todo);
            });
        if (isDelete is bool && isDelete) {
          await todoStorage.delete(todo);
        }
      },
      onDoubleTap: () async {
        var newTodoDesc = await showDialog(
            context: context,
            builder: (context) {
              return TodoEditDialog(todo: todo.description);
            });
        if (newTodoDesc == todo.description) return;
        newTodoDesc is String &&
            await todoStorage.updateTodo(todo, Todo.now(newTodoDesc));
      },
      child: TodoCardWidget(
        todo: todo,
        hidden: hidden,
      ),
    );
  }
}
