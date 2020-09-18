import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../size_config.dart';
import '../models/dark_mode.dart';
import '../models/timer.dart';

class BaseScreen extends StatefulWidget {
  final int navIndex;
  final Widget body;

  BaseScreen({this.navIndex, this.body});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  DateTime _lastTouchBack;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2<DarkModeModel, TimerService>(
      builder: (context, theme, timer, child) => Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(context),
        body: WillPopScope(
            child: widget.body,
            onWillPop: () async {
              if (_lastTouchBack == null ||
                  DateTime.now().difference(_lastTouchBack).inSeconds > 1) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Press again Back Button exit'),
                  duration: Duration(seconds: 1),
                ));
                _lastTouchBack = DateTime.now();
                return false;
              } else {
                timer.stopTimer();
                SystemNavigator.pop();
                return true;
              }
            }),
        bottomNavigationBar: buildNavBar(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: null,
      automaticallyImplyLeading: false,
      actions: [
        Consumer<DarkModeModel>(
          builder: (context, theme, child) => GestureDetector(
            onTap: () => theme.changeDarkMode(),
            child: SvgPicture.asset(
              theme.isDarkMode
                  ? "assets/icons/Moon.svg"
                  : "assets/icons/Sun.svg",
              height: 24,
              width: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/Settings.svg",
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  void _onItemTapped(int index) {
    if (index != widget.navIndex) {
      if (index == 0) {
        Navigator.pushNamed(context, '/task');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/calendar');
      }
    }
  }

  BottomNavigationBar buildNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Task'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Timer'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('Calendar'),
        ),
      ],
      currentIndex: widget.navIndex,
      selectedItemColor: Colors.red[500],
      onTap: _onItemTapped,
    );
  }
}
