import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants.dart';
import '../widgets/profile_list_item.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:maptrack/services/database.dart';
import 'package:maptrack/pages/conductor_device_tracking.dart';
import 'package:maptrack/services/auth.dart';

class Schedule extends StatelessWidget {
  String userID = "";
  Schedule({this.userID});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
        builder: (context) {
          return new MaterialApp(
            theme: ThemeProvider.of(context),
            home: new SchedulePage(driverId: userID),
          );
        },
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.driverId}) : super(key: key);

  final String driverId;

  @override
  _ConductorScheduleState createState() =>
      new _ConductorScheduleState(driverId);
}

class _ConductorScheduleState extends State<SchedulePage> {
  final AuthService _auth = AuthService();
  String driverId;
  _ConductorScheduleState(this.driverId);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Welcome!"), actions: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.person),
          label: Text("Log Out"),
          onPressed: () {
            _auth.signOut();
          },
        )
      ]),
      body: ListPage(driverId: driverId),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.driverId}) : super(key: key);

  final String driverId;
  @override
  _ListPageState createState() => _ListPageState(driverId);
}

class _ListPageState extends State<ListPage> {
  String driverId;
  _ListPageState(this.driverId);
  List busList = [];
  bool once = false;
  List hotspot = [];
  Map driverDetails = {};
  DatabaseService d = DatabaseService();

  void initList() {
    setState(() {
      once = true;
    });
    buildList(DateTime.now());
    getDriverDetails(widget.driverId);
  }

  void getDriverDetails(driverId) async {
    setState(() {
      driverDetails = {};
    });

    Map temp_driver_info = await d.getDriverInfoById(widget.driverId);

    setState(() {
      if (temp_driver_info.isNotEmpty) {
        // Check the bus schedule before adding to the list
        driverDetails = temp_driver_info;
      }
      //print(tempData);
    });
  }

  Future buildList(DateTime date) async {
    Map tempData = {};
    setState(() {
      busList = [];
    });

    tempData = await d.getRidesByDateAndOperator(date, driverId);
    setState(() {
      tempData.keys.forEach((busId) {
        if (busId != "") {
          // Check the bus schedule before adding to the list
          busList.add(tempData[busId]);
          print("tempData");
          print(tempData[busId].toString());
          print("checkvalue" + tempData[busId]["Route"]);
          _buildExpandableContent(tempData[busId]["Route"]);
        }
        //print(tempData);
      });
      //print(busList);
    });
  }

  Future<List> buildRoutes(busRouteNum) async {
    print("Enter build routes");
    print(busRouteNum);
    Map tempRoutes = {};
    List temp = [];
    List destList = [];

    tempRoutes = await d.getRouteByBusId(busRouteNum);
    setState(() {
      if (tempRoutes.isNotEmpty) {
        // Check the bus schedule before adding to the list
        temp = tempRoutes["Route"];

        temp.forEach((element) {
          destList.add(element.toString());
        });
      }
      //print(tempData);
    });
    print(destList);
    return (destList);
  }

  void _buildExpandableContent(routeNum) async {
    //List<Widget> columnContent = [];

    setState(() {
      hotspot = [];
    });

    List destList = await buildRoutes(routeNum);

    destList.forEach((element) async {
      Map temp = await d.checkIfSkip(element);
      List stopInfo = temp.values.toList();

      if (stopInfo[0] == true) {
        setState(() {
          hotspot.add(element.toString());
        });

        /*columnContent.add(
          new ListTile(
            title: new Text(
              element.toString(),
              style: new TextStyle(fontSize: 18.0, color: Colors.lightBlue),
            ),
          ),
        );*/
      }
      print(hotspot);
    });

    //return columnContent;
  }

  @override
  Widget build(BuildContext context) {
    if (once == false) {
      initList();
    }
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: AssetImage('assets/bus_driver2.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            driverDetails["Name"],
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            driverDetails["HealthStatus"] == true ? "Healthy" : "Not Healthy",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 3),
        ],
      ),
    );

    var datePicker = Column(
      children: <Widget>[
        Text(
          'Select Date',
          textAlign: TextAlign.start,
          style: kTitleTextStyle,
        ),
        Container(
          width: 300,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle:
                    TextStyle(color: Colors.white, fontSize: 15),
                pickerTextStyle: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            child: CupertinoDatePicker(
              backgroundColor: Colors.blueGrey,
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                buildList(newDateTime);
                //print(newDateTime);
              },
            ),
          ),
        ),
      ],
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        Icon(
          LineAwesomeIcons.arrow_left,
          size: ScreenUtil().setSp(kSpacingUnit.w * 3),
        ),
        profileInfo,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    //buildList();
    //print(busList);
    return Builder(builder: (context) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: kSpacingUnit.w * 5),
            header,
            datePicker,
            SizedBox(height: kSpacingUnit.w * 5),
            Expanded(
              child: ListView.builder(
                itemCount: busList.length,
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    color: Colors.grey[200],
                    child: ExpansionTile(
                      title: Text(
                        busList[i]["Route"] +
                            " / " +
                            DateFormat('kk:mm')
                                .format(busList[i]["DateTime"].toDate()),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        busList[i]["Vehicle number"],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      trailing: RaisedButton(
                        color: Colors.blueGrey,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConductorDeviceTracking(
                                busId: busList[i]["BusId"]),
                          ));
                        },
                        child: const Text('Start ride',
                            style: TextStyle(fontSize: 15)),
                      ),
                      children: <Widget>[
                        Container(
                          height: 150,
                          child: ListView.builder(
                              itemCount: hotspot.length,
                              itemBuilder: (BuildContext context, int child_i) {
                                return ListTile(
                                  leading: Icon(
                                      LineAwesomeIcons.exclamation_circle,
                                      color: Colors.red),
                                  title: new Text(
                                    hotspot[child_i],
                                    style: new TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
