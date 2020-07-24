import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:maptrack/models/user.dart';
import 'package:maptrack/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userRole = "hello";
  DatabaseService ds;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    if (user != null) {
      print(user);
      ds = DatabaseService(uid: user.uid);
      _getUserRole();
      // userRole = ds.getUserRole();
      // print(userRole);
      return User(uid: user.uid, role: 'manager');
      // return User(uid: user.uid, role: userRole);
    }
    return null;

    // return user != null ? User(uid: user.uid, role: 'driver') : null;
  }

  void _getUserRole() async {
    this.userRole = await ds.getUserRole();
    print(ds.uid);

    print(userRole);
    print("-----------------------------------");

  }

  // auth change user stream
  Stream<User> get user  {
    return _auth.onAuthStateChanged.map((FirebaseUser user) {
      return _userFromFirebaseUser(user);
    });
    // .map(await _userFromFirebaseUser);
  }

  // Sign In
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
