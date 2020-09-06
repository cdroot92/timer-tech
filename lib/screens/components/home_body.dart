import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/timer.dart';
import 'timer.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  FlutterLocalNotificationsPlugin _noti;

  int _runState = 0; // 0: stopped, 1: running, 2: paused
  String chanId = "timer_tech/timer";
  int timerNotiId = 92;

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

  Future<void> _startTimer(BuildContext context, String date, int min) async {
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
      'date: $date, min: $min',
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  Future<void> _stopTimer(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => TimerModel())],
        child: Container(
            child: Column(children: [
          Timer(),
          Consumer<TimerModel>(builder: (context, timer, build) {
            return Center(
                child: RaisedButton(
              child: Text("Start Background"),
              onPressed: () {
                _startTimer(context, timer.date, timer.min);
              },
            ));
          }),
          Center(
            child: RaisedButton(
              child: Text("Stop Background"),
              onPressed: () {
                _stopTimer(context);
              },
            ),
          )
        ])));
  }
}
