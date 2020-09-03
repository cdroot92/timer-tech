import 'package:flutter/material.dart';

class DarkModeModel extends ChangeNotifier {
  bool _isDarkMode = false;

  void changeDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
}
