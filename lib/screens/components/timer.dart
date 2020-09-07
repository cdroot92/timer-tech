import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/timer.dart' show TimerModel;
import 'timer_painter.dart' show TimerPainter;

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
    /*
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
            */
  }

  void runTimer() {
    timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      if (_sec > 0) {
        _sec--;
        sendNoti();
      } else {
        // finish
        finishTimer();
      }
    });
  }

  void startTimer(String date, int min) async {
    _date = date;
    _sec = min * 60;

    setState(() {
      _runState = 1;
    });

    sendNoti();
    runTimer();
  }

  void resumeTimer() async {
    setState(() {
      _runState = 1;
    });

    runTimer();
  }

  void pauseTimer() async {
    setState(() {
      _runState = 2;
    });

    timer.cancel();
  }

  void stopTimer(TimerModel m) async {
    setState(() {
      _runState = 0;
      _sec = 0;
    });

    timer.cancel();
    _noti.cancelAll();

    m.changeMin(0);
  }

  void clearTimer(TimerModel m) async {
    setState(() {
      _runState = 0;
      _sec = 0;
    });

    m.changeMin(0);
  }

  void finishTimer() async {
    setState(() {
      _runState = 0;
    });

    timer.cancel();
    _noti.cancelAll();
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

  void sendEndingNoti() async {}

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
      child: Stack(
        children: [
          Container(
            child: CustomPaint(painter: TimerPainter(context)),
          ),
          Consumer<TimerModel>(builder: (context, timer, build) {
            return Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        if (_runState == 1) {
                          pauseTimer();
                        } else if (_runState == 0) {
                          startTimer(timer.date, timer.min);
                        } else if (_runState == 2) {
                          resumeTimer();
                        }
                      },
                      tooltip: _runState == 1 ? 'Stop or Pause' : 'Start',
                      child: _runState == 1
                          ? new Icon(Icons.pause)
                          : new Icon(Icons.play_arrow),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (_runState == 0) {
                          clearTimer(timer);
                        } else {
                          stopTimer(timer);
                        }
                      },
                      tooltip: _runState == 0 ? 'Clear' : 'Stop',
                      child: _runState == 0
                          ? new Icon(Icons.refresh)
                          : new Icon(Icons.stop),
                    )
                  ],
                ));
          })
        ],
      ),
    );
  }
}
