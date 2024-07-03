import 'package:flutter/material.dart';
import 'package:inboxer2/storage/storage.dart';

class TodoDeleteDialog extends StatefulWidget {
  final Todo todo;
  const TodoDeleteDialog({super.key, required this.todo});

  @override
  _TodoDeleteDialogState createState() => _TodoDeleteDialogState();
}

class _TodoDeleteDialogState extends State<TodoDeleteDialog> {
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
