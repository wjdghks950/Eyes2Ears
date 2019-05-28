import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseUser user;
  static FirebaseStorage storage;
  static DocumentSnapshot currentSnapshot;
  static String defaultImgUrl = 'https://firebasestorage.googleapis.com/v0/b/eyes2ears-fff07.appspot.com/o/default_profile.png?alt=media&token=b6d36398-1309-42ff-bc21-eb559dec4493';

  AuthService();
}
