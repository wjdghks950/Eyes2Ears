import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'start.dart';


class EyesEars extends StatelessWidget {
  final appName = 'Eyes2Ears';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MallApp',
      home: MenuPage(),
      initialRoute: '/login',
      routes:{
        '/start': (context) => StartPage(),
        '/login': (context) => LoginPage(),
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