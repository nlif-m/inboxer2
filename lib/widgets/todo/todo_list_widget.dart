import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:inboxer2/services/config/config_service.dart';
import 'package:inboxer2/services/todo/todo_service.dart';
import 'todo_list_tile.dart';
import 'todo_add_dialog.dart';
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
      _intentDataStreamSubscription = ReceiveSharingIntent.instance
          .getMediaStream()
          .listen((List<SharedMediaFile> media) async {
        for (final media in media) {
          if (media.type == SharedMediaType.text) {
            final text = media.path;
            if (text.isNotEmpty) {
              await GetIt.I<TodoService>().add(Todo.now(text));
            }
          }
        }
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
    final todos = watchIt<TodoService>();
    final isHidden = watchValue((ConfigService c) => c.isHidden());

    final config = GetIt.I<ConfigService>();
    final todoStorage = GetIt.I<TodoService>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
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
