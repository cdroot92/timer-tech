import 'dart:isolate';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/timer.dart';
import 'timer_painter.dart';

class ClockTimer extends StatefulWidget {
  @override
  _ClockTimerState createState() => _ClockTimerState();
}

class _ClockTimerState extends State<ClockTimer> {
  FlutterLocalNotificationsPlugin _noti;
  String chanId = "timer_tech/timer";
  int timerNotiId = 92;
  Timer timer;

  int _runState = 0; // 0: stopped, 1: running, 2: paused
  int _sec = 0;
  String _date = "";

  void initState() {
    super.initState();
    var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSetting = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(androidSetting, iosSetting);

    _noti = FlutterLocalNotificationsPlugin();
    _noti.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
  }

  void startTimer(String date, int min) async {
    _date = date;
    _sec = min * 60;

    setState(() {
      _runState = 1;
    });
    sendNoti();
    timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _sec--;
      sendNoti();
    });
  }

  void sendNoti() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        chanId, chanId, chanId,
        importance: Importance.Low,
        visibility: NotificationVisibility.Public,
        priority: Priority.High);

    var iosPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

    await _noti.show(
      timerNotiId,
      'task명',
      'date: $_date, ${getTimerText()}',
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  void stopTimer() async {
    timer.cancel();
    _noti.cancelAll();

    setState(() {
      _runState = 0;
    });
  }

  String getTimerText() {
    var s = (_sec % 60).floor();
    var min = (_sec / 60.0).floor();
    var m = (min % 60.0).floor();
    var h = (min / 60.0).floor();

    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => TimerModel())],
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  painter: TimerPainter(context),
                ),
              ],
            ),
            Consumer<TimerModel>(builder: (context, timer, build) {
              return Center(
                  child: FloatingActionButton(
                onPressed: () {
                  if (_runState != 0) {
                    stopTimer();
                  } else {
                    startTimer(timer.date, timer.min);
                  }
                },
                tooltip: _runState != 0 ? 'Timer stop' : 'Timer start',
                child: _runState != 0
                    ? new Icon(Icons.stop)
                    : new Icon(Icons.play_arrow),
              ));
            })
          ],
        ));
  }
}
