import 'package:flutter/material.dart';
import 'dart:ui';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/londonbus.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          //   body: Container(
          // width: double.infinity,
          // decoration: BoxDecoration(
          //     color: Colors.grey[800],
          //     image: DecorationImage(
          //       image: AssetImage("assets/londonbus.jpg"),
          //     )),
          // child: ListView(
          body: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: <Widget>[
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 40,
                        // color: Colors.yellow,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 8
                          ..color = Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.yellow,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.yellow)),
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
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.yellow)),
                  child: TextField(
                    obscureText: true,
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
              Padding(
                padding: EdgeInsets.only(top:10, left: 220),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.yellow,
                  ),
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 5),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Colors.yellow,
                  textColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {},
                  child: Text(
                    "log in".toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),
              
            ],
          ),
        ),
      ],
    );
  }
}
