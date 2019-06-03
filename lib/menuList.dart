import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Custom_Icons.dart';
import 'data.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => new _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int _currentIndex = 0;
  Widget _buildGradientContainer(double width, double height) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: width * .8,
        height: height / 2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ 
                  Color(0xFF1b1e44),
                  Color(0xFF2d3447),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0])),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40.0,
      left: 20.0,
      right: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(CustomIcons.menu, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CustomIcons.search, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildTitle(double height) {
    return Positioned(
      top: height * .1,
      left: 30.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Menu",
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: "SF-Pro-Text-Regular",
                fontWeight:FontWeight.bold,
                color: Colors.white)),
          Text("Eyes2Ears",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "SF-Pro-Text-Regular",
                fontWeight:FontWeight.bold,
                color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildButton(String name, int index){
    String label = name.toLowerCase();
    Icon icon;
    if(label == 'music'){
      icon = Icon(Icons.music_note, color: (index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF30363d), size: 50.0);
    }
    else if(label == 'hear'){
      icon = Icon(Icons.forum, color:(index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF2a2d3f), size: 50.0);
    }
    else if(label == 'read'){
      icon = Icon(Icons.center_focus_weak, color: (index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF2a2d3f), size: 50.0);
    }
    else if(label == 'news'){
      icon = Icon(Icons.fiber_new, color:(index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF2a2d3f), size: 50.0);
    }
    else{
      icon = Icon(Icons.bubble_chart, color:(index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF2a2d3f), size: 50.0);
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF2d3447),
      body: LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              //_buildAppBar(),
              _buildTitle(height),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: height * .7,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('menulist').snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return LinearProgressIndicator();
                      }
                      List<Product> products = snapshot.data.documents.map((product) => Product.fromSnapshot(product)).toList();
                      return ListView.builder(
                        itemCount: images.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 35.0, bottom: 60.0),
                            child: SizedBox(
                              width: 250.0,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 45.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (index % 2 == 0)
                                              ? Colors.white
                                              : Color(0xFF5C6277),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(0.0, 10.0),
                                                blurRadius: 10.0)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          products[index].imgurl,
                                          fit: BoxFit.cover,
                                          width: 220.0,
                                          height: 220.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                            Text(products[index].name,
                                                style: TextStyle(
                                                    fontSize: 60.0,
                                                    fontFamily: "Montserrat-Bold",
                                                    color: (index % 2 == 0)
                                                        ? Color(0xFF2a2d3f)
                                                        : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                ),    
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(products[index].description,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Montserrat-Medium",
                                                    color: (index % 2 == 0)
                                                        ? Color(0xFF2a2d3f)
                                                        : Colors.white),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Center(
                                              child: ButtonTheme(
                                                minWidth: 150.0,
                                                height: 60.0,
                                                child: RaisedButton(
                                                  child: _buildButton(products[index].name, index),
                                                  splashColor: Color(0xFF5C6277),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  color: (index % 2 == 0)
                                                    ? Color(0xFF2a2d3f)
                                                    : Colors.white,
                                                  onPressed: (){
                                                    print(products[index].name + ' pressed!');
                                                    if(products[index].name.toLowerCase() == 'news'){
                                                      Navigator.of(context).pushNamed('/news');
                                                      print(products[index].name + ' pressed!');
                                                    }
                                                    else if(products[index].name.toLowerCase() == 'read'){
                                                      Navigator.of(context).pushNamed('/ocr');
                                                      print(products[index].name + ' pressed!');
                                                    }
                                                    else if(products[index].name.toLowerCase() == 'hear'){
                                                      Navigator.of(context).pushNamed('/speech');
                                                      print(products[index].name + ' pressed!');
                                                    }
                                                    else if(products[index].name.toLowerCase() == 'music'){
                                                      Navigator.of(context).pushNamed('/music');
                                                      print(products[index].name + ' pressed!');
                                                    }
                                                  }
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Product{
  final String name;
  final String imgurl;
  final String description;
  final String docID;
  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, String documentID, {this.reference})
    : assert(map['name'] != null),
      assert(map['imgurl'] != null),
      assert(map['description'] != null),
      name = map['name'],
      imgurl = map['imgurl'],
      description = map['description'],
      docID = documentID;

  Product.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

  @override
  String toString() => "<Product name: $name>";

}