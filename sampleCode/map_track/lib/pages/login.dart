import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:maptrack/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String errorText = "";

  String email = "";

  String password = "";

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
              Form(
                  key: _formKey,
                  child: Container(
                    height: 300,
                    child: ListView(children: <Widget>[
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
                          child: TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                              
                            },
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
                          child: TextFormField(
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() {
                              password = val;  
                              });
                              
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  // fontSize: 20,
                                )).copyWith(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 220),
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                  errorText =
                                      'Invalid Username or Password';  
                                  });
                                  
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          child: Text(
                            "log in".toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.yellow,
                            backgroundColor: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
