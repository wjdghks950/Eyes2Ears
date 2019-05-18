import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'start.dart';
import 'profile.dart';

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
        //'/music' : (context) => MusicPage(),
        //'/speech': (context) => SpeechTextPage(),
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