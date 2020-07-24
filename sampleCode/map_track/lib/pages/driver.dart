import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maptrack/services/auth.dart';

class Driver extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Page"), actions: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.person),
          label: Text("Log Out"),
          onPressed: () {
            _auth.signOut();
          },
        )
      ]),
    );
  }
}
