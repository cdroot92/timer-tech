import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tech/models/empty.dart';

import '../../models/timer.dart' show TimerService;
import 'timer_painter.dart' show TimerPainter;

class ClockTimer extends StatefulWidget {
  @override
  _ClockTimerState createState() => _ClockTimerState();
}

class _ClockTimerState extends State<ClockTimer> {
  double _x = 0;
  double _y = 0;
  Queue<int> degreeHistory = Queue();
  static const int historyLen = 3;

  Widget _buildButtonRow(TimerService timer) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: "start/pause",
              onPressed: () {
                if (timer.runState == 1) {
                  timer.pauseTimer();
                } else if (timer.runState == 0) {
                  timer.startTimer("2020-08-08");
                } else if (timer.runState == 2) {
                  timer.resumeTimer();
                }
              },
              tooltip: timer.runState == 1 ? 'Stop or Pause' : 'Start',
              child: timer.runState == 1
                  ? new Icon(Icons.pause)
                  : new Icon(Icons.play_arrow),
            ),
            FloatingActionButton(
              heroTag: "reset/stop",
              onPressed: () {
                if (timer.runState == 0) {
                  timer.clearTimer();
                } else {
                  timer.stopTimer();
                }
              },
              tooltip: timer.runState == 0 ? 'Clear' : 'Stop',
              child: timer.runState == 0
                  ? new Icon(Icons.refresh)
                  : new Icon(Icons.stop),
            )
          ],
        ));
  }

  _setStartTimer(BuildContext context, DragStartDetails details, double centerX,
      double centerY, TimerService timer) {
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(details.globalPosition);
    _x = local.dx;
    _y = local.dy;

    int degree = _calcDegree(_x, _y, centerX, centerY);
    setState(() {
      timer.setSec(timer.hour * 3600 + degree * 10);
    });
  }

  _setUpdateTimer(BuildContext context, DragUpdateDetails details,
      double centerX, double centerY, TimerService timer) {
    _x += details.delta.dx;
    _y += details.delta.dy;

    int degree = _calcDegree(_x, _y, centerX, centerY);
    _addToDegreeHistory(degree);

    int check = _checkTwelve();
    if (!(check == -1 && timer.hour == 0)) {
      timer.addHour(check);
    }

    timer.setSec(timer.hour * 3600 + degree * 10);
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

    theta = (theta / 6).floor() * 6;

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
      providers: [ChangeNotifierProvider(create: (context) => EmptyModel())],
      child: Consumer<TimerService>(builder: (context, timerService, build) {
        double screenWidth = MediaQuery.of(context).size.width;
        double topMargin = 30;
        double centerX = screenWidth / 2;
        double centerY = screenWidth / 2 + topMargin;

        return Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "${timerService.timeText}",
              style: TextStyle(fontSize: 35),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: topMargin),
              child: CustomPaint(
                painter: TimerPainter(context, timerService.sec),
                child: Container(
                  width: screenWidth,
                  height: screenWidth,
                ),
              ),
            ),
            onPanStart: (details) {
              if (timerService.runState == 0) {
                _setStartTimer(
                    context, details, centerX, centerY, timerService);
              }
            },
            onPanUpdate: (details) {
              if (timerService.runState == 0) {
                _setUpdateTimer(
                    context, details, centerX, centerY, timerService);
              }
            },
            onPanEnd: (details) {
              if (timerService.runState == 0) {
                _setEndTimer(context, details);
              }
            },
          ),
          _buildButtonRow(timerService),
        ]);
      }),
    );
  }
}
