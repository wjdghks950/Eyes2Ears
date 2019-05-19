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
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1b1e44),
                            Color(0xFF2d3447),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90)
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.person,
                              size: 90,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 62),
                      child: Column(
                        children: <Widget>[
                          Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50)
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              ),
                              onTap: (){
                                print("Google sign-in!");
                                _handleGoogleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)); //Pop up google sign in
                              },
                              child: 
                              Container(
                                width: MediaQuery.of(context).size.width/1.2,
                                height: 100,
                                //margin: EdgeInsets.only(top: 32),
                                padding: EdgeInsets.only(
                                    top: 4,left: 16, right: 16, bottom: 4
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.purpleAccent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50)
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
                                      child: Text('Google Sign-in',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          fontFamily: "Calibre-Semibold",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50)
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              ),                    
                              onTap: (){
                                print("Login!");
                                _handleAnonymous().then((FirebaseUser user) => print(user)).catchError((e) => print(e));
                              },
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width/1.2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1b1e44),
                                      Color(0xFF2d3447),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50)
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
                                      child: Text('Login'.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          fontFamily: "Calibre-Semibold",
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
              ),
        ],
      ),
    );
  }
}