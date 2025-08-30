import 'package:inboxer2/services/config/config.dart';
import 'package:inboxer2/servives/todo/todo.dart';

export 'package:inboxer2/services/config/config.dart';
export 'package:inboxer2/services/todo/todo.dart';

class Storage {
  ConfigStorage configStorage;
  TodoStorage todoStorage;

  Storage({required this.configStorage, required this.todoStorage});
}
