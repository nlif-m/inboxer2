import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:inboxer2/storage/config/config.dart';
import 'package:inboxer2/storage/todo/todo.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:watch_it/watch_it.dart';

class TodoListWidget extends WatchingStatefulWidget {
  const TodoListWidget({super.key});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  late StreamSubscription _intentDataStreamSubscription;
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String value) async {
        await GetIt.I<TodoStorage>().add(Todo.now(value));
      }, onError: (err) {});
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _intentDataStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final todos = watchIt<TodoStorage>();
    final isHidden = watchValue((ConfigStorage c) => c.isHidden());

    final config = GetIt.I<ConfigStorage>();
    final todoStorage = GetIt.I<TodoStorage>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
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
