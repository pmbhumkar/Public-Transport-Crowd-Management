import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maptrack/services/auth.dart';
import 'package:maptrack/pages/temp.dart';

class Driver extends StatelessWidget {
  final AuthService _auth = AuthService();
  String userID = "";
  Driver({this.userID});

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
      body: Container(
        child: Center(
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempTimer()));
            },
            child: Text(userID),
          ),            
          ),
        ),
    );
  }
}
