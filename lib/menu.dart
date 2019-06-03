import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuList.dart';
import 'profile.dart';
import 'group.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => new _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;
  final List<Widget> _pageList = [
    ProfilePage(),
    MenuList(),
    GroupPage(),
  ];
  @override
  void initState(){
    _currentIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF30363d),
      body: _pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size:40.0),
              title: Container(
                height: 0.0,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 40.0, color: Colors.white),
              title: Container(
                height: 0.0,
              )),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, size: 40.0),
            title: Container(
              height: 0.0,
            )),
        ],
      ),
      floatingActionButton: Container(
        width: 65.0,
        height: 65.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF27A54),
              Color(0xFFA154F2)
            ],
          ),
          color: Color(0xFFfa7b58),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 3.0),
                blurRadius: 10.0)
          ]),
        child: RawMaterialButton(
          shape: CircleBorder(),
          child: Icon(
            Icons.home,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: () {
            setState((){
              _currentIndex = 1;
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}