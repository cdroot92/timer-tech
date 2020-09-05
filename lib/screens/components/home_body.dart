import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:timer_tech/models/timer.dart';

import 'timer.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const _android = const MethodChannel('timertech.dev/timer');
  int _runState = 0; // 0: stopped, 1: running, 2: paused

  Future<void> _startTimer(BuildContext context, String date, int min) async {
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        var args = <String, dynamic>{'date': date, 'min': min};
        String data = await _android.invokeMethod('startTimer', args);
        debugPrint(data);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _stopTimer(BuildContext context) async {
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        String data = await _android.invokeMethod('stopTimer');
        debugPrint(data);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

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
