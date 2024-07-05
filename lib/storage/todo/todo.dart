import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inboxer2/storage/config/config.dart';
import 'package:inboxer2/storage/todo/todo_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

export 'package:inboxer2/storage/todo/todo_model.dart';
export 'package:inboxer2/storage/todo/todo_add_dialog.dart';
export 'package:inboxer2/storage/todo/todo_list_tile.dart';
export 'package:inboxer2/storage/todo/todo_list_widget.dart';

abstract class TodoStorage extends ChangeNotifier {
  ValueNotifier<List<Todo>> todos();
  Future<void> add(Todo todo);
  Future<bool> delete(Todo todo);
  Future<void> init();
  Future<void> update();
  // ignore: non_constant_identifier_names
  Future<bool> updateTodo(Todo old, Todo New);
}

class TodoStorageInboxFile extends TodoStorage {
  static const inboxHeader = "#+filetags: inbox\n";
  late ValueNotifier<List<Todo>> _todos;
  late StreamSubscription _intentDataStreamSubscription;
  StreamSubscription<FileSystemEvent>? _inboxEventStream;

  @override
  Future<void> init() async {
    _todos = ValueNotifier<List<Todo>>(await _readTodos());
    if (Platform.isAndroid) {
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String value) async {
        await GetIt.I<TodoStorage>().add(Todo.now(value));
        notifyListeners();
      }, onError: (err) {});
    }
    notifyListeners();

    innerFunc(event) async {
      var todos = await _readTodos();
      _todos.value = todos;
      notifyListeners();
    }

    _inboxEventStream = GetIt.I<ConfigStorage>()
        .inboxFile
        .value!
        .watch(events: FileSystemEvent.modify)
        .listen(innerFunc);
    (GetIt.I<ConfigStorage>().inboxFile).addListener(() async {
      if (_inboxEventStream != null) {
        await _inboxEventStream!.cancel();
      }
      _inboxEventStream = GetIt.I<ConfigStorage>()
          .inboxFile
          .value!
          .watch(events: FileSystemEvent.modify)
          .listen(innerFunc);
    });
  }

  @override
  ValueNotifier<List<Todo>> todos() {
    return _todos;
  }

  @override
  Future<void> add(Todo todo) async {
    _todos.value.add(todo);
    sortNewerFirst();
    await update();
    notifyListeners();
  }

  @override
  Future<bool> delete(Todo todo) async {
    var index = _todos.value.indexWhere((t) => t == todo);
    if (index == -1) return false;
    _todos.value.removeAt(index);
    await update();
    notifyListeners();
    return true;
  }

  @override
  Future<void> update() async {
    sortNewerFirst();
    _writeTodos(_todos.value);
    notifyListeners();
  }

  @override
  // ignore: non_constant_identifier_names
  Future<bool> updateTodo(Todo old, Todo New) async {
    var index = _todos.value.indexOf(old);
    if (index == -1) return false;
    _todos.value[index] = New;

    notifyListeners();
    return true;
  }

  Future<List<Todo>> _readTodos() async {
    File inboxFile = await _inbox();
    if (!await inboxFile.exists()) {
      await inboxFile.create();
    }

    String content = await inboxFile.readAsString();
    return Todo.fromString(content);
  }

  String _asStringFile() {
    var todosText = _todos.value.map((e) => e.asOrgTodo());
    return [inboxHeader, ...todosText].join();
  }

  void _writeTodos(List<Todo> todos) async {
    (await _inbox()).writeAsString(_asStringFile());
  }

  void sortNewerFirst() {
    (_todos.value).sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : 0);
    notifyListeners();
  }

  Future<File> _inbox() async {
    return await GetIt.I<ConfigStorage>().inbox;
  }
}
