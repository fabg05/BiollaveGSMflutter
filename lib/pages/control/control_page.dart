import 'package:flutter/material.dart';
import 'package:navigation_bar_2021curso/pages/control/control_screen.dart';

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control Page',
      home: ControlScreen(),
    );
  }
}

