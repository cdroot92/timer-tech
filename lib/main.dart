// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/dark_mode.dart';
import 'models/timer.dart';
import 'screens/home.dart' show HomeScreen;
import 'screens/task.dart' show TaskScreen;
import 'screens/calendar.dart' show CalendarScreen;
import 'theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Route generateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return new PageRouteBuilder(pageBuilder: (_, a1, a2) => HomeScreen());
    } else if (settings.name == "/task") {
      return new PageRouteBuilder(pageBuilder: (_, a1, a2) => TaskScreen());
    } else if (settings.name == "/calendar") {
      return new PageRouteBuilder(pageBuilder: (_, a1, a2) => CalendarScreen());
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
        child: Consumer<DarkModeModel>(
            builder: (context, theme, child) => MaterialApp(
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
