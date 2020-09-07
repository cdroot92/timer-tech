import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  String _date = "2020-08-08";
  int _min = 30;

  String get date => _date;
  int get min => _min;

  void changeDate(String date) {
    _date = date;
    notifyListeners();
  }

  void changeMin(int min) {
    _min = min;
    notifyListeners();
  }
}
