import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';
import '../models/dark_mode.dart';
import 'components/home_body.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: HomeBody(),
    );
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
}
