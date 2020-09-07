import 'dart:async';
import 'dart:collection';
import 'dart:math';

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
  int _hour = 0;
  String _date = "";

  double _x = 0;
  double _y = 0;
  Queue<int> degreeHistory = Queue();
  static const int historyLen = 3;

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

  Future onSelectNotification(String payload) async {}

  void runTimer() {
    timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      if (_sec > 0) {
        setState(() {
          _sec--;
        });
        sendNoti();
      } else {
        // finish
        finishTimer();
      }
    });
  }

  void startTimer(String date) async {
    _date = date;

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
      _hour = 0;
    });

    timer.cancel();
    _noti.cancelAll();

    m.changeMin(0);
  }

  void clearTimer(TimerModel m) async {
    setState(() {
      _runState = 0;
      _sec = 0;
      _hour = 0;
    });

    m.changeMin(0);
  }

  void finishTimer() async {
    setState(() {
      _runState = 0;
      _sec = 0;
      _hour = 0;
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

    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Widget _buildButtonRow(TimerModel timer) {
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
                  startTimer(timer.date);
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
  }

  _setStartTimer(BuildContext context, DragStartDetails details, double centerX,
      double centerY) {
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(details.globalPosition);
    _x = local.dx;
    _y = local.dy;

    int degree = _calcDegree(_x, _y, centerX, centerY);
    setState(() {
      _sec = _hour * 3600 + degree * 10;
    });
  }

  _setUpdateTimer(BuildContext context, DragUpdateDetails details,
      double centerX, double centerY) {
    _x += details.delta.dx;
    _y += details.delta.dy;

    int degree = _calcDegree(_x, _y, centerX, centerY);
    _addToDegreeHistory(degree);

    int check = _checkTwelve();
    if (!(check == -1 && _hour == 0)) {
      _hour += check;
    }
    setState(() {
      _sec = _hour * 3600 + degree * 10;
    });
  }

  _setEndTimer(BuildContext context, DragEndDetails details) {
    _x = 0;
    _y = 0;
    degreeHistory = Queue();
  }

  int _calcDegree(double toX, double toY, double centerX, double centerY) {
    var theta = (atan2(toY - centerY, toX - centerX) * 180 / pi).round();
    theta = theta < 0 ? theta + 360 : theta;

    // rotate
    theta = theta > 270 ? theta - 270 : theta + 90;

    //theta = (theta / 6).floor() * 6;

    return theta;
  }

  _addToDegreeHistory(int degree) {
    if (degreeHistory.length < historyLen) {
      degreeHistory.addLast(degree);
    } else {
      degreeHistory.removeFirst();
      degreeHistory.addLast(degree);
    }
  }

  int _checkTwelve() {
    if (degreeHistory.length == historyLen) {
      List<int> tmp = degreeHistory.toList();
      double frontAvg = (tmp[0] + tmp[1]) / 2;
      double rearAvg = (tmp[1] + tmp[2]) / 2;

      if (frontAvg > 300 && rearAvg < 200) {
        return 1;
      } else if (frontAvg < 200 && rearAvg > 300) {
        return -1;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => TimerModel())],
      child: Consumer<TimerModel>(builder: (context, timerModel, build) {
        double screenWidth = MediaQuery.of(context).size.width;
        double topMargin = 30;
        double centerX = screenWidth / 2;
        double centerY = screenWidth / 2 + topMargin;

        return Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "${getTimerText()}",
              style: TextStyle(fontSize: 35),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: topMargin),
              child: CustomPaint(
                painter: TimerPainter(context, _sec),
                child: Container(
                  width: screenWidth,
                  height: screenWidth,
                ),
              ),
            ),
            onPanStart: (details) {
              if (_runState == 0) {
                _setStartTimer(context, details, centerX, centerY);
              }
            },
            onPanUpdate: (details) {
              if (_runState == 0) {
                _setUpdateTimer(context, details, centerX, centerY);
              }
            },
            onPanEnd: (details) {
              if (_runState == 0) {
                _setEndTimer(context, details);
              }
            },
          ),
          _buildButtonRow(timerModel),
        ]);
      }),
    );
  }
}
