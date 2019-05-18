import 'package:flutter/material.dart';
import 'start.dart';

void main() => runApp(EyesEars());

class EyesEars extends StatelessWidget{
  final appName = 'Eyes2Ears';
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: appName,
      home: StartPage(name: appName),
    );
  }
}