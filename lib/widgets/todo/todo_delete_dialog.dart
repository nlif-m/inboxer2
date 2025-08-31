import 'package:flutter/material.dart';
import 'package:inboxer2/services/services.dart';

class TodoDeleteDialog extends StatefulWidget {
  final Todo todo;
  const TodoDeleteDialog({super.key, required this.todo});

  @override
  TodoDeleteDialogState createState() => TodoDeleteDialogState();
}

class TodoDeleteDialogState extends State<TodoDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(super.widget.todo.asOrgTodo()),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("delete")),
      ],
    );
  }
}
