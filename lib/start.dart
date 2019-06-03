import 'package:flutter/material.dart';

/* The starting page of the application
1) Logo
2) Application name */

class StartPage extends StatelessWidget{
  final String name;

  StartPage({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: name,
      home: GestureDetector(
        onTap: (){
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Scaffold(
          backgroundColor: Color(0xFF30363d),
          body: Stack(
            children: [
              Positioned.fill(
                top: MediaQuery.of(context).size.height / 3.0,
                child: Column(
                  children: [
                    Icon(
                      Icons.all_inclusive,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 10.0),
                    //SizedBox(height: MediaQuery.of(context).size.height / 10.0),
                    Text("Eyes2Ears",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF-Pro-Text-Bold',
                        fontSize: MediaQuery.of(context).size.width / 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), //Starting page
    );
  }
}