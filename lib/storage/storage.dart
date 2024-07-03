import 'package:inboxer2/storage/config/config.dart';
import 'package:inboxer2/storage/todo/todo.dart';

export 'package:inboxer2/storage/config/config.dart';
export 'package:inboxer2/storage/todo/todo.dart';

class Storage {
  ConfigStorage configStorage;
  TodoStorage todoStorage;

  Storage({required this.configStorage, required this.todoStorage});
}
