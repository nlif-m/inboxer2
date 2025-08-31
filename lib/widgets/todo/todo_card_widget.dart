import 'package:flutter/material.dart';

import 'package:inboxer2/services/services.dart';

class TodoCardWidget extends StatelessWidget {
  final bool hidden;
  final Todo todo;
  const TodoCardWidget({super.key, required this.todo, this.hidden = false});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      height: 56,
      child: hidden
          ? const Center(child: Text("[REDACTED]"))
          : Text(todo.asOrgTodo()),
    ));
  }
}
