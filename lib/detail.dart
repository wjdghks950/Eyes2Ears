import 'package:flutter/material.dart';
import 'group.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({Key key, @required this.product}) : super(key : key);

  @override
  _DetailState createState() => new _DetailState(this.product);
}

class _DetailState extends State<DetailPage> {
  final Product product;

  _DetailState(this.product);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF2d3447),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DetailScreenTopPart(product: this.product),
            DetailScreenInfo(product: this.product),
          ],
        ),
      ),
    );
  }
}

class DetailScreenTopPart extends StatefulWidget{
  final Product product;

  DetailScreenTopPart({Key key, @required this.product}) : super(key : key);

  @override
  _DetailScreenTopPartState createState() => _DetailScreenTopPartState();
}

class _DetailScreenTopPartState extends State<DetailScreenTopPart> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 350.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: Mclipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ]),
              child: Stack(
                children: <Widget>[
                  Image.network(widget.product.imgurl,
                      fit: BoxFit.cover, width: double.infinity),
                ],
              ),
            ),
          ),
          Positioned(
            top: 300.0,
            right: -20.0,
            child: FractionalTranslation(
              translation: Offset(0.0, -0.5),
              child: Row(
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState((){
                        if(!_liked){
                          _liked = true;
                        }
                        else{
                          _liked = false;
                        }
                      });
                    },
                    child: Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xFFE52020),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: RaisedButton(
                      highlightElevation: 10.0,
                      elevation:10.0,
                      onPressed: () {},
                      color: Color(0xFF735d3f).withOpacity(0.9),// Color(0xFF735d3f),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 80.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.product.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
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

class DetailScreenInfo extends StatefulWidget{
  final Product product;

  DetailScreenInfo({Key key, @required this.product}) : super(key : key);

  @override
  _DetailScreenInfoState createState() => _DetailScreenInfoState(this.product);
}

class _DetailScreenInfoState extends State<DetailScreenInfo> {
  final Product product;

  _DetailScreenInfoState(this.product);

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text(
            widget.product.fullname,
            style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontFamily: "SF-Pro-Display-Bold"),
          ),
          SizedBox(height: 30.0),
          Divider(color: Colors.white, height: 5.0),
          SizedBox(height: 30.0),
          Text(
            widget.product.phoneNum,
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontFamily: "SF-Pro-Display-Bold"),
          ),
          SizedBox(height: 30.0),
          Divider(color: Colors.white, height: 5.0),
          SizedBox(height: 30.0),
          Text(
            widget.product.address,
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontFamily: "SF-Pro-Display-Bold"),
          ),
          SizedBox(height: 30.0),
          Divider(color: Colors.white, height: 5.0),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

}


class DetailScreenBottomPart extends StatelessWidget {
  final Product product;

  DetailScreenBottomPart(this.product);

  List<String> images = [
    "assets/images/runaways.jpg",
    "assets/images/avengers.jpg",
    "assets/images/blackpanther.jpg"
  ];

  List<String> titles = ["Runaways", "Avengers: infinity war", "Black Panther"];

  List<Widget> movies() {
    List<Widget> movieList = new List();

    for (int i = 0; i < 3; i++) {
      var movieitem = Padding(
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
                  fit: BoxFit.contain,
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
                child: Text(i == 0 ? "Season 2" : ""),
              )
            ],
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
