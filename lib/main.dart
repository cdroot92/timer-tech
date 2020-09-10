// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tech/screens/components/home_body.dart';

import 'models/dark_mode.dart';
import 'models/timer.dart';
import 'screens/base.dart' show BaseScreen;
import 'theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Route generateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return new PageRouteBuilder(
          pageBuilder: (_, a1, a2) => BaseScreen(
                navIndex: 1,
                body: HomeBody(),
              ));
    } else if (settings.name == "/task") {
      return new PageRouteBuilder(
        pageBuilder: (_, a1, a2) =>
            BaseScreen(navIndex: 0, body: Center(child: Text("Task Body"))),
      );
    } else if (settings.name == "/calendar") {
      return new PageRouteBuilder(
          pageBuilder: (_, a1, a2) => BaseScreen(
                navIndex: 2,
                body: Center(child: Text("Calendar Body")),
              ));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimerService()),
          ChangeNotifierProvider(create: (context) => DarkModeModel())
        ],
        child: Consumer2<DarkModeModel, TimerService>(
            builder: (context, theme, timer, child) => MaterialApp(
                  title: 'Timer Tech',
                  theme: themeData(context),
                  darkTheme: darkThemeData(context),
                  themeMode:
                      theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  initialRoute: '/',
                  onGenerateRoute: generateRoute,
                )));
  }
}
