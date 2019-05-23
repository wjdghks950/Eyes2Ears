import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'start.dart';
import 'profile.dart';
import 'speech2.dart';
import 'menuList.dart';
import 'detail.dart';

class AppPage extends StatelessWidget {
  final appName = 'Eyes2Ears';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: MenuPage(),
      initialRoute: '/start',
      routes:{
        '/start': (context) => StartPage(name: appName),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
        '/menu':(context) => MenuList(),
        '/speech': (context) => SpeechPage(),
        '/detail': (context) => DetailPage(),
        //'/music' : (context) => MusicPage(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}