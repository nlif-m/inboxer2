import 'dart:io';

import 'package:flutter/material.dart';

export 'package:inboxer2/storage/config/config_prefs.dart';

abstract class ConfigStorage {
  late ValueNotifier<bool> _isHidden;
  ValueNotifier<bool> isHidden();
  late ValueNotifier<File?> inboxFile;
  void setHidden(bool hidden) => _isHidden.value = hidden;
  String inboxFileName = "refile.org";
  Future<File> get inbox async {
    throw UnimplementedError("abstract class");
  }

  Future<File> askInbox();
}
