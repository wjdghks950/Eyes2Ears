import 'package:flutter/material.dart';
import 'customicon.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => new _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[HomeScreeTopPart(), HomeScreenBottomPart()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color(0xFF4A148C)),
              title: Text("Home", style: TextStyle(color: Color(0xFF4A148C)))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text("Search", style: TextStyle())),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_border,
              ),
              title: Text(
                "Bookmark",
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text("Profile"))
        ],
      ),
    );
  }
}

class HomeScreeTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 420.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: Mclipper(),
            child: Container(
              height: 370.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ]),
              child: Stack(
                children: <Widget>[
                  Image.asset("assets/images/old.jpg",
                      fit: BoxFit.cover, width: double.infinity),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0x00000000),
                              const Color(0xD9333333)
                            ],
                            stops: [
                              0.0,
                              0.9
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(0.0, 1.0))),
                    child: Padding(
                      padding: EdgeInsets.only(top: 120.0, left: 95.0),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 370.0,
            right: -20.0,
            child: FractionalTranslation(
              translation: Offset(0.0, -0.5),
              child: Row(
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: RaisedButton(
                      onPressed: () {},
                      color: Color(0xFF4A148C),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 80.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Watch Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RotatedBox(
                            quarterTurns: 2,
                            child: Icon(Icons.arrow_back,
                                size: 25.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreenBottomPart extends StatefulWidget {
  @override
  _HomeScreenBottomPartState createState() => new _HomeScreenBottomPartState();
}

class _HomeScreenBottomPartState extends State<HomeScreenBottomPart> {

  @override
  initState() {
    super.initState();
  }

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://youtu.be/BZpIQnPdsSQ",
    );
  }

  void playYoutubeVideo2() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://youtu.be/DNrK0yhrz0A",
    );
  }

  void playYoutubeVideo3() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://youtu.be/woSCgIhRl9s",
    );
  }

  List<String> images = [
    "assets/images/radio.png",
    "assets/images/beatles.png",
    "assets/images/lovesong.png"
  ];

  List<String> titles = ["Radio Hits", "Beatles Songs", "Love Songs"];

  List<Widget> movies() {
    List<Widget> movieList = new List();

    for (int i = 0; i < 3; i++) {
      var movieitem = GestureDetector(
        onTap: (){
          setState(() {
            if(i==0){
              playYoutubeVideo();
            }
            if(i==1){
              playYoutubeVideo2();
            }
            if(i==2){
              playYoutubeVideo3();
            }
          });

        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 12.0),
          child: Container(
            height: 220.0,
            width: 135.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0))
                ]),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  child: Image.asset(
                    images[i],
                    width: double.infinity,
                    height: 130.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                  child: Text(titles[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontFamily: "SF-Pro-Display-Bold")),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0),
                  //child: Text(i == 0 ? "Amy Nuttall" : ""),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(i == 0 ? "" : ""),
                      Text(i == 1 ? "" : ""),
                      Text(i == 2 ? "" : ""),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
      movieList.add(movieitem);
    }
    return movieList;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 360.0,
      margin: EdgeInsets.only(left: 65.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Watch now",
                  style: TextStyle(
                      fontSize: 22.0, fontFamily: "SF-Pro-Display-Bold"),
                ),
                FlatButton(
                  child: Text("View more"),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
            height: 250.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: movies(),
            ),
          )
        ],
      ),
    );
  }
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 100.0);

    var controlpoint = Offset(35.0, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}