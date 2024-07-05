import 'package:flutter/material.dart';

import 'package:inboxer2/main.dart';
import 'package:inboxer2/storage/config/config.dart';
import 'package:inboxer2/storage/todo/todo.dart';
import 'package:watch_it/watch_it.dart';

class TodoListWidget extends StatelessWidget with WatchItMixin {
  TodoListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final todos = watchIt<TodoStorage>();
    final isHidden = watchValue((ConfigStorage c) => c.isHidden());

    final config = getIt<ConfigStorage>();
    final todoStorage = getIt<TodoStorage>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async {
                await config.askInbox();
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () async {
                await todoStorage.update();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                config.setHidden(!isHidden);
              },
              icon: isHidden
                  ? const Icon(Icons.source)
                  : const Icon(Icons.hide_source)),
        ],
      ),
      floatingActionButton: IconButton(
        color: Colors.black,
        onPressed: () async {
          var userTodo = await showDialog(
              context: context,
              builder: (context) {
                return const TodoAddDialog();
              });
          if (userTodo is String && userTodo.isNotEmpty) {
            await todoStorage.add(Todo.now(userTodo));
          }
        },
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
          itemCount: todos.todos().value.length,
          itemBuilder: (context, index) {
            return TodoListTile(
                todo: todos.todos().value[index], hidden: isHidden);
          }),
    );
  }
}
