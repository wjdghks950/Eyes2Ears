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
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/startpage_people.jpg"), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  SizedBox(height: 100.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          child: Stack(
                            children: <Widget>[
                              Container( 
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 100.0,
                                height: 100.0,
                                child: Text('E', 
                                  style: TextStyle(
                                    fontFamily: 'Kaushan Script' , //TODO: Need to import Kaushan Script font
                                    color: Colors.white,
                                    fontSize: 100.0,
                                    fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                alignment: Alignment(0.25, -0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ], 
              ),
          ),
          ],
        ),
      ), //Starting page
    );
  }
}