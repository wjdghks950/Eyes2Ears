import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'auth.dart';

class MenuPage extends StatefulWidget{
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          }
        ),
        brightness: Brightness.light,
        title: Text('Main',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/item');
            },
          ),
        ],
      ),
      body: 
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: 
                            Firestore.instance.collection('menulist').documents().snapshots(),
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
    );
  }

  List<Card> _buildGridCards(BuildContext context, List<Product> products){
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString()
    );
    
    if (products == null || products.isEmpty){ // In case the list of products is empty
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);

    return products.map((product){
      return Card(
        clipBehavior: Clip.antiAlias, // You can make it into a radius
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imgurl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 16.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:10.0),
                  Text(
                    product == null ? '' : product.name,
                    style: theme.textTheme.button,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines:1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 8.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left:8.0)),
                  Flexible(
                    child:Text(
                      product == null ? '' : formatter.format(product.price).toString(),
                      style: TextStyle(fontSize:10.0),
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
                        AuthService.currentSnapshot = await Firestore.instance.collection('products').document(product.docID).get();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product)));
                       } // Product's index
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}

class Product{
  final String name;
  final String category;
  final String description;
  final String imgurl;
  final int likes;
  final double price;
  final String uid;
  final DateTime created;
  final DateTime modified;
  final String docID;
  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, String documentID, {this.reference})
    : assert(map['name'] != null),
      assert(map['category'] != null),
      assert(map['description'] != null),
      assert(map['imgurl'] != null),
      assert(map['likes'] != null),
      assert(map['price'] != null),
      assert(map['uid'] != null),
      assert(map['created'] != null),
      assert(map['modified'] != null),
      name = map['name'],
      category = map['category'],
      description = map['description'],
      imgurl = map['imgurl'],
      likes = map['likes'],
      price = map['price'].toDouble(),
      uid = map['uid'],
      created = map['created'],
      modified = map['modified'],
      docID = documentID;

  Product.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

  @override
  String toString() => "<Product name: $name - Category: $category - Price: $price>";

}

Widget buildStar(BuildContext context, int numstars, bool detail){ // Generate random number of stars (from 1 to 5)
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      numstars, 
      (index) => Icon(
        Icons.star, 
        color: Colors.yellow, 
        size: detail ? 25.0 : 10.0,
      ),
    ),
  );
}

  