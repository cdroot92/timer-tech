import 'package:flutter/material.dart';

class DarkModeModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void changeDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
