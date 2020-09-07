import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  String _date = "2020-08-08";
  int _min = 72;

  String get date => _date;
  int get min => _min;
  int get hour => (_min / 60).floor();

  void changeDate(String date) {
    _date = date;
    notifyListeners();
  }

  void changeMin(int min) {
    _min = min;
    notifyListeners();
  }
}
