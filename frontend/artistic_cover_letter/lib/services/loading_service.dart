import 'package:flutter/material.dart';

class LoadingService {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
