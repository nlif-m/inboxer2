import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inboxer2/services/services.dart';
import 'package:inboxer2/widgets/todo/todo_list_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
    status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) await Permission.manageExternalStorage.request();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  ConfigService configStorage =
      await ConfigServicePrefs.withAsk(prefs: prefs, force: false);

  GetIt.I.registerSingleton<ConfigService>(configStorage);

  TodoService todoStorage = TodoServiceInboxFile(config: configStorage);
  await todoStorage.init();
  GetIt.I.registerSingleton<TodoService>(todoStorage);

  if (Platform.isAndroid) {
    ReceiveSharingIntent.instance.getInitialMedia().then(
      (medias) async {
        for (final media in medias) {
          if (media.type == SharedMediaType.text) {
            final text = media.path;
            if (text.isNotEmpty) {
              await todoStorage.add(Todo.now(text));
            }
          }
        }
      },
    );
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoListWidget(),
    );
  }
}
