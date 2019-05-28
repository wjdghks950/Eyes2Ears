import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'start.dart';
import 'profile.dart';
import 'menuList.dart';
import 'detail.dart';
import 'ocr.dart';
import 'speech.dart';
// import 'music.dart';

class AppPage extends StatelessWidget {
  final appName = 'Eyes2Ears';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: MenuPage(),
      initialRoute: '/start',
      routes:{
        '/appPage': (context) => AppPage(),
        '/start': (context) => StartPage(name: appName),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
        '/menu':(context) => MenuList(),
        '/detail': (context) => DetailPage(),
        '/ocr': (context) => OCRPage(),
        '/speech': (context) => TranscriptorWidget(),
        // '/music' : (context) => MusicPage(),
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