import 'dart:math';

import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final BuildContext context;

  TimerPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
