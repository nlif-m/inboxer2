import 'dart:core';

class Todo {
  late String description;
  late DateTime createdAt;

  static const orgTodoDescriptionRegexp = r"\* TODO (.+)\n";
  static const orgTodoCreatedAtRegexp = r"\[(.*)\]\n";
  static const orgTodoRegexp =
      "$orgTodoDescriptionRegexp$orgTodoCreatedAtRegexp";

  Todo(this.description, this.createdAt) {
    description = description.replaceAll("\n", " ");
    createdAt = createdAt;
  }

  Todo.now(this.description) {
    description = description.replaceAll("\n", " ");
    createdAt = DateTime.now();
  }

  String asOrgTodo([int level = 1]) {
    var levelString = [for (var i = 0; i < level; i++) "*"].join();
    return "$levelString TODO $description\n${toOrgTime(createdAt)}\n";
  }

  static String _atLeastTwoDigits(int number) {
    return number.toString().padLeft(2, 0.toString());
  }

  static String toOrgTime(DateTime time) {
    var datePart = [
      _atLeastTwoDigits(time.year),
      _atLeastTwoDigits(time.month),
      _atLeastTwoDigits(time.day)
    ].join("-");
    var timePart = [
      _atLeastTwoDigits(time.hour),
      _atLeastTwoDigits(time.minute),
      _atLeastTwoDigits(time.second)
    ].join(":");
    return "[$datePart $timePart]";
  }

  static List<Todo> fromString(String input) {
    List<Todo> todos = [];
    for (var match in RegExp(orgTodoRegexp).allMatches(input)) {
      var desc = match.group(1)!;
      var time = DateTime.parse(match.group(2)!);

      todos.add(Todo(
        desc,
        time,
      ));
    }
    return todos;
  }

  @override
  String toString() {
    return "Todo(description: $description, createdAt: $createdAt)";
  }
}
