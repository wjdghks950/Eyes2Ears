import 'package:flutter/material.dart';
import 'auth.dart';

class ProfilePage extends StatefulWidget{
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>{

  void _signout() async{
    if(AuthService.user.isAnonymous){
      await AuthService.auth.signOut();
    }
    else if(AuthService.user.isEmailVerified){
      await AuthService.googleSignIn.signOut();
      await AuthService.googleSignIn.disconnect();
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Color(0xFF2d3447)),
          clipper: getClipper(),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(
                                AuthService.user.isAnonymous ? AuthService.defaultImgUrl : AuthService.user.photoUrl),
                            fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ],
                      ),
                    ),
                SizedBox(height: 90.0),
                Text(
                  AuthService.user.isAnonymous ? "Guest User" : AuthService.user.displayName,
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  AuthService.user.isAnonymous ? '' : AuthService.user.email,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 50.0,
                  width: 200.0,
                  child: RaisedButton(
                    elevation: 5.0,
                    child: Row(
                      children: [
                        Icon(Icons.image, color: Colors.white, size: 40.0),
                        SizedBox(width: MediaQuery.of(context).size.width / 25.0,),
                        Text(
                          'Edit Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,),),
                      ],
                    ),
                    onPressed: (){
                      // TODO: image picker
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: Colors.green
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 50.0,
                  width: 200.0,
                  child: RaisedButton(
                    elevation: 5.0,
                    child: Row(
                      children: [
                        Icon(Icons.bubble_chart, color: Colors.white, size: 40.0),
                        SizedBox(width: MediaQuery.of(context).size.width / 25.0,),
                        Text(
                          'LOG OUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,),),
                      ],
                    ),
                    onPressed: (){
                      _signout();
                      Navigator.of(context).pushNamedAndRemoveUntil('/appPage', (Route<dynamic> route) => false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    color: Colors.red,
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height/2.7);

    var firstControlPoint = Offset(size.width / 4, size.height / 2.0);
    var firstEndPoint = Offset(size.width / 2.25, size.height / 2.7);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height / 3.5);
    var secondEndPoint = Offset(size.width, size.height / 2.7);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2.5);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

// class _ProfileState extends State<ProfilePage>{

//   void _signout() async{
//     if(AuthService.user.isAnonymous){
//       await AuthService.auth.signOut();
//     }
//     else if(AuthService.user.isEmailVerified){
//       await AuthService.googleSignIn.signOut();
//       await AuthService.googleSignIn.disconnect();
//     }
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         title: Text('Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             color: Colors.white,
//             onPressed: (){
//               _signout();
//               print(AuthService.user.toString() + ' signed out successfully');
//               Navigator.of(context).pushNamedAndRemoveUntil('/start', (Route<dynamic> route) => false);
//             },
//           ),
//         ]
//       ),
//       backgroundColor: Color(0xFF2d3447),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
//         children: [
//           Container(
//             child: AuthService.user.isAnonymous ? Image.network(AuthService.defaultImgUrl) : Image.network(AuthService.user.photoUrl),
//           ),
//           Column(
//             children:[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     AuthService.user.uid,
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       color: Colors.white,
//                     )
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: Divider(
//                   color: Colors.white,
//                   height: 3.0
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     AuthService.user.isAnonymous ? 'Anonymous' : AuthService.user.email,
//                     style: TextStyle(
//                       fontSize: 10.0,
//                       color: Colors.white,
//                     )
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }