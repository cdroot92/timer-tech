import 'package:flutter/material.dart';

import 'timer_painter.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: TimerPainter(context),
        )
      ],
    );
  }
}
