import 'package:flutter/material.dart';

class TodoEditDialog extends StatefulWidget {
  final String todo;
  TodoEditDialog({super.key, required this.todo});

  @override
  _TodoEditDialogState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends State<TodoEditDialog> {
  String _todoDescription = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        initialValue: super.widget.todo,
        onChanged: (value) {
          _todoDescription = value;
        },
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_todoDescription);
            },
            child: Text("Save"))
      ],
    );
  }
}
