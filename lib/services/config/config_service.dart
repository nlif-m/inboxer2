import 'dart:io';

export 'config_service.dart';
export 'config_service_prefs.dart';

import 'package:flutter/material.dart';

abstract class ConfigService {
  late ValueNotifier<bool> _isHidden;
  ValueNotifier<bool> isHidden();
  late ValueNotifier<File?> inboxFile;
  void setHidden(bool hidden) => _isHidden.value = hidden;
  // TODO: Make it dynamic
  static String inboxFileName = "refile.org";
  Future<File> get inbox async {
    throw UnimplementedError("abstract class");
  }

  Future<File> askInbox();
}
