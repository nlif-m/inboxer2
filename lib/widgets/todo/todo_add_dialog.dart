import 'package:flutter/material.dart';

class TodoAddDialog extends StatefulWidget {
  const TodoAddDialog({super.key});

  @override
  TodoAddDialogState createState() => TodoAddDialogState();
}

class TodoAddDialogState extends State<TodoAddDialog> {
  String _userTodo = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Insert todo"),
      content: TextFormField(
        autofocus: true,
        initialValue: _userTodo,
        onChanged: (value) {
          setState(() {
            _userTodo = value;
          });
        },
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(_userTodo);
            },
            child: const Text("save")),
      ],
    );
  }
}
