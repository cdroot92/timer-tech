import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tech/models/empty.dart';

import 'timer.dart' show ClockTimer;

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => EmptyModel())],
        child: Container(
            child: Column(children: [
          ClockTimer(),
        ])));
  }
}
