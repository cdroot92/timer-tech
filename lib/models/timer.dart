import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerService extends ChangeNotifier {
  Timer _timer;
  int _runState = 0; // 0: stopped, 1: running, 2: paused

  FlutterLocalNotificationsPlugin _noti;
  String chanId = "timer_tech/timer";
  int timerNotiId = 92;

  String _date = "2020-08-08";
  int _hour = 0;
  int _sec = 0;

  String get date => _date;
  int get hour => _hour;
  int get sec => _sec;
  int get runState => _runState;

  String get timeText {
    var s = (_sec % 60).floor();
    var min = (_sec / 60.0).floor();
    var m = (min % 60.0).floor();
    var h = (min / 60.0).floor();

    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  TimerService() {
    var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSetting = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(androidSetting, iosSetting);

    _noti = FlutterLocalNotificationsPlugin();
    _noti.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {}

  void sendNoti() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      chanId,
      chanId,
      chanId,
      importance: Importance.Low,
      priority: Priority.Low,
      visibility: NotificationVisibility.Public,
    );

    var iosPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

    await _noti.show(
      timerNotiId,
      'task명',
      'date: $_date, $timeText',
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  void changeDate(String date) {
    _date = date;
    notifyListeners();
  }

  void addHour(int check) {
    _hour += check;
    notifyListeners();
  }

  void setSec(int sec) {
    _sec = sec;
    notifyListeners();
  }

  void runTimer() {
    _timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      if (_sec > 0) {
        _sec--;
        notifyListeners();
        sendNoti();
      } else {
        // finish
        finishTimer();
      }
    });
  }

  void startTimer(String date) async {
    _date = date;
    _runState = 1;
    notifyListeners();

    sendNoti();
    runTimer();
  }

  void resumeTimer() async {
    _runState = 1;
    notifyListeners();

    runTimer();
  }

  void pauseTimer() async {
    _runState = 2;
    notifyListeners();

    _timer.cancel();
  }

  void stopTimer() async {
    _runState = 0;
    _sec = 0;
    _hour = 0;
    notifyListeners();

    _timer.cancel();
    _noti.cancelAll();
  }

  void clearTimer() async {
    _runState = 0;
    _sec = 0;
    _hour = 0;
    notifyListeners();
  }

  void finishTimer() async {
    _runState = 0;
    _sec = 0;
    _hour = 0;
    notifyListeners();

    _timer.cancel();
    _noti.cancelAll();
  }
}
