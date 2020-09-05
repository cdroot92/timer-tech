import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  String _date = "2020-08-08";
  int _min = 3;

  String get date => _date;
  int get min => _min;
  int get hour => (_min / 60).floor();

  void changeDate(String date) {
    _date = date;
    notifyListeners();
  }

  void changeTime(int, min) {
    _min = min;
    notifyListeners();
  }
}
