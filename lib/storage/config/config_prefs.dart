import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inboxer2/main.dart';
import 'package:inboxer2/storage/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ConfigStoragePrefs extends ConfigStorage {
  final SharedPreferences prefs;
  static const String _inboxFileKey = "config.inboxFile";
  final ValueNotifier<bool> _isHidden = ValueNotifier(true);

  @override
  ValueNotifier<bool> isHidden() => _isHidden;

  @override
  void setHidden(bool hidden) {
    _isHidden.value = hidden;
  }

  ConfigStoragePrefs._({required this.prefs, File? file}) {
    inboxFile = ValueNotifier(file);
  }

  @override
  Future<File> get inbox async {
    File? f;
    if (inboxFile.value != null) {
      f = inboxFile.value!;
    } else {
      f = await _askForInboxFile(prefs: prefs);
      inboxFile.value = f;
    }

    if (!await f.exists()) {
      await f.create();
    }
    return f;
  }

  @override
  Future<File> askInbox() async {
    inboxFile.value = await ConfigStoragePrefs._askForInboxFile(prefs: prefs);
    await prefs.setString(_inboxFileKey, inboxFile.value!.path);
    return inboxFile.value!;
  }

  static Future<ConfigStoragePrefs> withAsk(
      {required SharedPreferences prefs, bool force = false}) async {
    String? fileString = prefs.getString(_inboxFileKey);
    File? f = fileString == null ? null : File(fileString);
    if (force || f == null) {
      f = await ConfigStoragePrefs._askForInboxFile(prefs: prefs);
      await prefs.setString(_inboxFileKey, f.path);
    }

    return ConfigStoragePrefs._(prefs: prefs, file: f);
  }

  static Future<File> _askForInboxFile(
      {required SharedPreferences prefs}) async {
    String? dir;
    do {
      dir = await FilePicker.platform.getDirectoryPath();
    } while (dir == null);
    dir = path.join(dir, getIt<ConfigStorage>().inboxFileName);
    return File(dir);
  }
}
