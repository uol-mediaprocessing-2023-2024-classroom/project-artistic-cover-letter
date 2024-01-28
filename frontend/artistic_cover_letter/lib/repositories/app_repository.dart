import 'package:flutter/material.dart';

class AppRepository {
  ValueNotifier<bool> isLogout = ValueNotifier(false);

  void setLogout(bool value) {
    isLogout.value = value;
  }
}
