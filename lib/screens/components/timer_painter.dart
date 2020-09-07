import 'dart:math';

import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final BuildContext context;

  int _sec;

  TimerPainter(this.context, this._sec);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double r = size.width / 2 * 0.8;
    Rect rect = Rect.fromCircle(center: center, radius: r);
    Rect largeRect = Rect.fromCircle(center: center, radius: r + 10);
    Paint paint = Paint();
    int h = _sec ~/ 3600;
    int colorWeight = h < 9 ? h + 1 : 9;
    paint.color = Colors.pink[100 * colorWeight];
    if (_sec ~/ 3600 >= 1) {
      canvas.drawArc(largeRect, 0, degreeToRadian(360), true, paint);
    }
    paint.color = Colors.redAccent;
    canvas.drawArc(rect, degreeToRadian(270), degreeToRadian(_sec % 3600 * 0.1),
        true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double radianToDegree(double rad) {
    return rad * 180 / pi;
  }

  double degreeToRadian(double deg) {
    return deg / 180 * pi;
  }
}
