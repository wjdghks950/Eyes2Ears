import 'package:flutter/material.dart';
import 'customicon.dart';
import 'package:youtube_player/youtube_player.dart';

class MusicPage extends StatefulWidget {
  var displayImg = "assets/old.jpg";
  var youtubePage;
  @override
  _MusicPageState createState() => new _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFF2d3447),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              HomeScreenTopPart(displayImg: widget.displayImg, youtubePage: widget.youtubePage,),
              HomeScreenBottomPart(displayImg: widget.displayImg, youtubePage: widget.youtubePage,)],
          ),
        ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget{
  var displayImg;
  var youtubePage;
  HomeScreenTopPart({Key key, @required displayImg, @required youtubePage}) : super(key : key);

  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
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
                  Image.asset("assets/old.jpg",
                      fit: BoxFit.cover, width: double.infinity),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
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
                      color: Color(0xFF2d3447),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: RaisedButton(
                      elevation: 10.0,
                      highlightElevation: 10.0,
                      onPressed: () {},
                      color: Color(0xFFa38a6a),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Watch Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
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
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class HomeScreenBottomPart extends StatefulWidget {
  var displayImg;
  var youtubePage;
  HomeScreenBottomPart({Key key, @required displayImg, @required youtubePage}) : super(key : key);

  @override
  _HomeScreenBottomPartState createState() => new _HomeScreenBottomPartState();
}

class _HomeScreenBottomPartState extends State<HomeScreenBottomPart> {

  List<String> images = [
    "assets/radio.jpg",
    "assets/beatles.png",
    "assets/lovesong.png"
  ];
  
  List<String> titles = ["Radio Hits", "Beatles Songs", "Love Songs"];

  List<Widget> movies() {
    List<Widget> movieList = new List();

    for (int i = 0; i < 3; i++) {
      var movieitem = GestureDetector(
        onTap: (){
          setState(() {
            if(i==0){
              Navigator.pushNamed(context, '/video');
            }
            if(i==1){
              widget.displayImg = images[1];
              Navigator.pushNamed(context, '/video2');
            }
            if(i==2){
              widget.displayImg = images[2];
              Navigator.pushNamed(context, '/video3');
            }
            print(widget.displayImg);
          });

        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 12.0),
          child: Container(
            height: 600.0,
            width: 250.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: 
                  AssetImage(
                    images[i],
                  ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
              ),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0))
                ],
              ),
            child: Stack(
              children: [
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                    top: MediaQuery.of(context).size.height/6.0,
                    width: MediaQuery.of(context).size.width/2.5,
                    child: Container(
                      color: Colors.transparent,
                      child: Text(titles[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 33.0, 
                            fontFamily: "SF-Pro-Display-Bold",
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                  ),
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
      margin: EdgeInsets.only(left: 0.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Click to view more",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0, fontFamily: "SF-Pro-Display-Bold"),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/2.8,
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
