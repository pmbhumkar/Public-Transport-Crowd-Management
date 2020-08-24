import 'package:flutter/material.dart';
import 'package:maptrack/services/auth.dart';
import 'package:maptrack/services/database.dart';
import 'package:maptrack/pages/operator_health.dart';
import 'package:maptrack/pages/hotspot_update.dart';
import 'package:maptrack/pages/bus_sanitization.dart';


class ManagerPage extends StatefulWidget {
  String userID = "";
  ManagerPage({this.userID});

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  final AuthService _auth = AuthService();
  final backColor = Colors.grey[800];
  String name = "";
  DatabaseService ds = DatabaseService();

  void getUserName() async {
    String s = await ds.getUserName(widget.userID);
    setState(() {
      name = s;
    });

  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        // title: Text("Staff Manager"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _auth.signOut();
            },
          ),
        ],
        backgroundColor: backColor,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            color: backColor,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://www.w3schools.com/bootstrap4/img_avatar4.png'),
                      fit: BoxFit.fill),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                color: backColor,
                border: Border(
                    bottom: BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ))),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: Container(
            color: backColor,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.yellow,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OperatorHealth(),
                        ));
                      },
                      child: Text(
                        "Operator Health",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.yellow,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BusSanitization(),
                        ));
                      },
                      child: Text(
                        "Bus Sanitization",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.yellow,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HotSpotUpdate(),
                        ));
                      },
                      child: Text(
                        "Hotspot",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.yellow,
                      onPressed: () {},
                      child: Text(
                        "Trends",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
