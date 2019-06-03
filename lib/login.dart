import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
    bool _success = false;
  String _uid;

  Future<FirebaseUser> _handleGoogleSignIn() async{
    final GoogleSignInAccount googleUser = await AuthService.googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    if(googleUser == null){
      print('Google login failed!');
      return null;
    }

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await AuthService.auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    print(user.email);
    print(user.displayName);
    print(user.isAnonymous);
    print(user.getIdToken());

    final FirebaseUser currentUser = await AuthService.auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState((){
      if(user != null){
        _success = true;
        _uid = user.uid;
        AuthService.user = user;
        Firestore.instance.collection('accounts').document('google').setData({
          'email' : user.email,
          'photourl': user.photoUrl,
          'displayName' : user.displayName,
        });
        Navigator.pop(context);
      }
      else{
        _success = false;
      }
    });
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _handleAnonymous() async{
    final FirebaseUser user = await AuthService.auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if(Platform.isIOS){
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    }
    else if(Platform.isAndroid){
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
    }

    final FirebaseUser currentUser = await AuthService.auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState((){
      if(user != null){
        _success = true;
        _uid = user.uid;
        AuthService.user = user;
        print('Successfully signed in as a guest [uid]: ' + _uid);
        Navigator.pop(context);
        Firestore.instance.collection('accounts').document('anonymous').setData({
            'uid' : user.email,
            'isAnonymous': user.isAnonymous,
            'displayName' : user.displayName,
        });
      }
      else{
        _success = false;
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30363d),
      body: Stack(
            children: <Widget>[
              Positioned.fill(
                top: MediaQuery.of(context).size.height / 5.0,
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
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 1.5),
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(75)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(75)
                        ),
                        onTap: (){
                          print("Google sign-in!");
                          _handleGoogleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)); //Pop up google sign in
                        },
                        child: 
                        Container(
                          width: MediaQuery.of(context).size.width/1.2,
                          height: 75,
                          //margin: EdgeInsets.only(top: 32),
                          padding: EdgeInsets.only(
                              top: 4,left: 16, right: 16, bottom: 4
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF27A54),
                                Color(0xFFA154F2)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4.0,
                              ),
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(75)
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[ 
                              Image.asset(
                                "assets/google-logo.png",
                                scale: 5.0,  
                              ),
                              SizedBox(width: 20.0),
                              Center(
                                child: Text('Google Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27.0,
                                    fontFamily: "Brandon_reg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(75)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(75)
                        ),
                        onTap: (){
                          print("Login!");
                          _handleAnonymous().then((FirebaseUser user) => print(user)).catchError((e) => print(e));
                        },
                        child: Container(
                          height: 75,
                          width: MediaQuery.of(context).size.width/1.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFF27A54),
                                Color(0xFFA154F2)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4.0,
                              ),
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(75)
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[ 
                              Icon(Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(width: 20.0),
                              Center(
                                child: Text('Guest Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27.0,
                                    fontFamily: "Brandon_reg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
        ],
      ),
    );
  }
}