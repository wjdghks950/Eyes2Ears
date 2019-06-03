import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'start.dart';
import 'profile.dart';
import 'menuList.dart';
import 'detail.dart';
import 'ocr.dart';
import 'speech.dart';
import 'addfriend.dart';
import 'music.dart';
import 'video_detail.dart';
import 'group.dart';

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
        '/group': (context) => GroupPage(),
        '/detail': (context) => DetailPage(),
        '/ocr': (context) => OCRPage(),
        '/speech': (context) => TranscriptorWidget(),
        '/addItem': (context) => AddItem(),
        '/music' : (context) => MusicPage(),
        '/video' : (context) => VideoDetail(),
        '/video2' : (context) => VideoDetail2(),
        '/video3' : (context) => VideoDetail3(),
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