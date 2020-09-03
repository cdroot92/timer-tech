// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/dark_mode.dart';
import 'screens/home.dart';
import 'theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DarkModeModel(),
        child: Consumer<DarkModeModel>(
            builder: (context, theme, child) => MaterialApp(
                title: 'Timer Tech',
                theme: themeData(context),
                darkTheme: darkThemeData(context),
                themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                home: HomeScreen())));
  }
}
