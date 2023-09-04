import 'package:flutter/material.dart';
import 'package:navigation_bar_2021curso/pages/control/control_page.dart';
import 'package:navigation_bar_2021curso/pages/profiles/profiles_page.dart';
import 'package:navigation_bar_2021curso/pages/settings/settings_page.dart';
import 'package:navigation_bar_2021curso/provider/resize_provider.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ResizeProvider())],
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    ControlPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (globals.isAdmin == false) {
        if (index != 2) {
          _selectedIndex = index;
        }
      } else {
        _selectedIndex = index;
      }

      // switch (index) {
      //   case 0:
      //     {
      //       _title = 'Perfil';
      //     }
      //     break;
      //   case 1:
      //     {
      //       _title = 'Control';
      //     }
      //     break;
      //   case 2:
      //     {
      //       _title = 'Ajustes';
      //     }
      //     break;
      // }
    });
  }

  @override
  initState() {
    super.initState();
    // getSavedProfile().whenComplete(() {
    //   setState(() {
    //     if (_savedProfile == '') {
    //       _selectedIndex = 0;
    //     } else {
    //       _selectedIndex = 1;
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Scaffold(
        drawer: Drawer(),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp),
              label: 'Perfil',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_made),
              label: 'Control',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
              backgroundColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
