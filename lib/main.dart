import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inboxer2/storage/storage.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
    status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) await Permission.manageExternalStorage.request();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  ConfigStorage configStorage =
      await ConfigStoragePrefs.withAsk(prefs: prefs, force: false);
  getIt.registerSingleton<ConfigStorage>(configStorage);

  TodoStorage todoStorage = TodoStorageInboxFile();
  await todoStorage.init();
  getIt.registerSingleton<TodoStorage>(todoStorage);

  Storage storage =
      Storage(configStorage: configStorage, todoStorage: todoStorage);
  getIt.registerSingleton<Storage>(storage);

  if (Platform.isAndroid) {
    ReceiveSharingIntent.getInitialText().then((value) async {
      if (value != null && value.isNotEmpty) {
        await todoStorage.add(Todo.now(value));
        exit(0);
      }
    });
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListWidget(),
    );
  }
}
