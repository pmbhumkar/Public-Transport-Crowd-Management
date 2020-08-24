import 'package:flutter/material.dart';
import 'package:maptrack/pages/trend_charts_drivers.dart';
import 'package:maptrack/pages/trend_charts_passengers.dart';
import 'package:maptrack/pages/trends_charts_bus_sanitization.dart';
import 'package:maptrack/pages/trend_chart_route.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  Color commonColor = Colors.grey[500];
  Color trendColor = Colors.grey[300];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text("Trends"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: commonColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: Text(
                    "Number of Drivers violating norms current month",
                    style: TextStyle(fontSize: 17),
                  ))),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: trendColor,
                border: Border(
                    bottom: BorderSide(
                  color: Colors.white,
                  width: 4.0,
                )),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Text(
                        "10",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))),
                      FlatButton(
                        color: Colors.yellow,
                        child: Text("Montly trends"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarGraphDrivers(),
                        ));
                        },
                      )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: commonColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: Text(
                    "Number of passengers violating norms current month",
                    style: TextStyle(fontSize: 17),
                  ))),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: trendColor,
                border: Border(
                    bottom: BorderSide(
                  color: Colors.white,
                  width: 4.0,
                )),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Text(
                        "28",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))),
                      FlatButton(
                        color: Colors.yellow,
                        child: Text("Montly trends"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarGraphPassengers(),
                        ));
                        },
                      )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: commonColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(
                      "Lapse in bus sanitization current month",
                      style: TextStyle(fontSize: 17),
                    ),
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: trendColor,
                border: Border(
                    bottom: BorderSide(
                  color: Colors.white,
                  width: 4.0,
                )),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Text(
                        "5",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))),
                      FlatButton(
                        color: Colors.yellow,
                        child: Text("Montly trends"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarGraphBuses(),
                        ));
                        },
                      )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: commonColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: Text(
                    "Routes in which safety norms were violated in the current month",
                    style: TextStyle(fontSize: 17),
                  ))),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: trendColor,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Text(
                        "20",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))),
                      FlatButton(
                        color: Colors.yellow,
                        child: Text("Route trends"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PieChartRoutes(),
                        ));
                        },
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
