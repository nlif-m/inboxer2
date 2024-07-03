import 'dart:io';

import 'package:flutter/material.dart';

export 'package:inboxer2/storage/config/config_prefs.dart';

abstract class ConfigStorage {
  late ValueNotifier<bool> _isHidden;
  ValueNotifier<bool> isHidden();
  void setHidden(bool hidden) => _isHidden.value = hidden;
  Future<File> get inbox async {
    // TODO: implement inbox
    throw UnimplementedError();
  }

  Future<File> askInbox();
}
