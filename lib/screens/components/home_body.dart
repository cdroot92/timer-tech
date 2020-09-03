import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

import 'timer.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  /*
  static const android = const MethodChannel('timertech.dev/timer');

  Future<void> _startTimer(BuildContext context) async {
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        String data = await android.invokeMethod('startTimer');
        debugPrint(data);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Timer(),
      Center(
        child: RaisedButton(
          child: Text("Start Background"),
          onPressed: () {},
        ),
      )
    ]));
  }
}
