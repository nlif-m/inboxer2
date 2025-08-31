import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:inboxer2/services/services.dart';

class TodoServiceInboxFile extends TodoService {
  TodoServiceInboxFile({required ConfigService config}) : _config = config;

  static const _inboxHeader = "#+filetags: inbox\n";
  final ConfigService _config;
  late ValueNotifier<List<Todo>> _todos;
  StreamSubscription<FileSystemEvent>? _inboxEventStream;

  @override
  Future<void> init() async {
    _todos = ValueNotifier<List<Todo>>(await _readTodos());
    notifyListeners();

    innerFunc(event) async {
      var todos = await _readTodos();
      _todos.value = todos;
      notifyListeners();
    }

    _inboxEventStream = _config.inboxFile.value!
        .watch(events: FileSystemEvent.modify)
        .listen(innerFunc);
    (_config.inboxFile).addListener(() async {
      if (_inboxEventStream != null) {
        await _inboxEventStream!.cancel();
      }
      _inboxEventStream = _config.inboxFile.value!
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
  Future<bool> updateTodo(Todo old, Todo new_) async {
    var index = _todos.value.indexOf(old);
    if (index == -1) return false;
    _todos.value[index] = new_;

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
    return [_inboxHeader, ...todosText].join();
  }

  void _writeTodos(List<Todo> todos) async {
    (await _inbox()).writeAsString(_asStringFile());
  }

  void sortNewerFirst() {
    (_todos.value).sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : 0);
    notifyListeners();
  }

  Future<File> _inbox() async {
    return await _config.inbox;
  }
}
