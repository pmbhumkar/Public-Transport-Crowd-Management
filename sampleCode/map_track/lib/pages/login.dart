import 'package:flutter/material.dart';
import 'dart:ui';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
//      backgroundColor: Colors.indigo[100],
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[800],
          image: DecorationImage(
            image: AssetImage("assets/londonbus.jpg"),
          )),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            "LOGIN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                    hintText: "Username",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      // fontSize: 20,
                    )),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      // fontSize: 20,
                    )),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: InkWell(

            ),
          )
        ],
      ),
    ));
  }
}
