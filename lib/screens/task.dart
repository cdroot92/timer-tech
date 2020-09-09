import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';
import '../models/dark_mode.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Text('Task Screen'),
        ),
      ),
      bottomNavigationBar: buildNavBar(context),
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushNamed(context, '/task');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/calendar');
      }
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: null,
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
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red[500],
      onTap: _onItemTapped,
    );
  }
}
