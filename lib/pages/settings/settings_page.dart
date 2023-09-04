import 'package:flutter/material.dart';
import 'package:navigation_bar_2021curso/pages/settings/settings_main_screen.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Login UI',
        debugShowCheckedModeBanner: false,
        home: SettingsMainScreen());
  }
}
