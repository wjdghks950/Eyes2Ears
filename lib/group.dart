import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'detail.dart';

class GroupPage extends StatefulWidget{
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String _imageUrl;
  String _defaultUrl = "assets/startpage_people.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2d3447),
      body: 
        NestedScrollView(
          headerSliverBuilder : (context, innerBoxIsScrolled){
            return [
              SliverAppBar(
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 30.0,
                      onPressed: (){
                        print("Add pressed!");
                      },
                    )
                  ),
                ],
                backgroundColor: Color.fromRGBO(0,0,0,0),
                expandedHeight: 500.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row( 
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(
                    "Group",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),]
                  ),
                  background: _imageUrl == null ? Image.asset(_defaultUrl, fit: BoxFit.cover) :Image.network(_imageUrl , fit: BoxFit.cover),
                ),
              ),
            ];
          },
        body: Column(
            children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('group').snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return null;
                      }
                      List<Product> products = snapshot.data.documents.map((product) => Product.fromSnapshot(product)).toList();
                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16.0),
                        childAspectRatio: 8.0 / 9.0,
                        children: _buildGridCards(context, products),
                      );
                    },
                  ),
                ),
              ],
          ),
      ),
    );
  }

  List<GestureDetector> _buildGridCards(BuildContext context, List<Product> products){
    
    if (products == null || products.isEmpty){ // In case the list of products is empty
      return const <GestureDetector>[];
    }
    final ThemeData theme = Theme.of(context);

    return products.map((product){
      return GestureDetector(
        onTap : () {
          setState((){
            _imageUrl = product.imgurl;
          });
          print(product.name);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.antiAlias, // You can make it into a radius
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    product.imgurl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 5.0, 16.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height:10.0),
                    Text(
                      product == null ? '' : product.name,
                      style: TextStyle(
                        color: Color(0xFF5C6277),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines:1,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child:Text(
                        product == null ? '' : product.phoneNum.toString(),
                        style: TextStyle(fontSize:12.0),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  SizedBox(
                    width: 60.0,
                    height: 20.0,
                    child: FlatButton(
                        child: Text('more',
                          style: TextStyle(
                            fontFamily:'Rubik',
                            fontSize: 10.0,
                            color: Colors.blue[400],
                          ),
                        ),
                        onPressed: () async{ 
                          AuthService.currentSnapshot = await Firestore.instance.collection('friends').document(product.docID).get();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: product)));
                        } // Product's index
                      ),
                    ),
                ],
              ),
            ],
          ),
      ),
    );
    }).toList();
  }
}

class Product{
  final String name;
  final String imgurl;
  final bool favorite;
  final String phoneNum;
  final String docID;
  final String fullname;
  final String address;
  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, String documentID, {this.reference})
    : assert(map['name'] != null),
      assert(map['imgurl'] != null),
      assert(map['favorite'] != null),
      assert(map['phoneNum'] != null),
      assert(map['fullname'] != null),
      assert(map['address'] != null),
      name = map['name'],
      imgurl = map['imgurl'],
      favorite = map['favorite'],
      phoneNum = map['phoneNum'],
      fullname = map['fullname'],
      address = map['address'],
      docID = documentID;

  Product.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

  @override
  String toString() => "<Product name: $name>";

}

  