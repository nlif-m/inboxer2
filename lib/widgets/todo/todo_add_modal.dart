import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoAddModal extends StatefulWidget {
  const TodoAddModal({super.key});

  @override
  State<TodoAddModal> createState() => _TodoAddModalState();
}

class _TodoAddModalState extends State<TodoAddModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _todoTextControler;
  @override
  void initState() {
    super.initState();
    _todoTextControler = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _todoTextControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _todoTextControler,
            )
          ],
        ));
  }
}
