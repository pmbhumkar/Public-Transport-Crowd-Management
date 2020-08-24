import 'package:flutter/material.dart';
import 'package:maptrack/services/database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusSanitization extends StatefulWidget {
  static final backColor = Colors.grey[800];

  @override
  _BusSanitizationState createState() => _BusSanitizationState();
}

class _BusSanitizationState extends State<BusSanitization> {
  final route = TextEditingController(text: "");
  DatabaseService ds = DatabaseService();
  List busList = [];
  List busIDs = [];
  String line1 = "";
  String line2 = "";
  DateTime _select_date = DateTime.now();
  DateTime _current_date = DateTime.now();
  static var dateList = [];
  static var date;
  Timestamp ts;
  // List<bool> _bus_check = [];

  void getOperatorData() async {
    setState(() {
      busList = [];
      line1 = "";
      line2 = "";
    });
    if (route.text != "") {
      Map buses = await ds.getBusInfoFromRoutes(route.text);
      setState(() {
        buses.keys.forEach((element) {
          dateList.add(DateTime.fromMicrosecondsSinceEpoch(
              buses[element]["LastSanitized"].microsecondsSinceEpoch));
          busList.add(buses[element]);
          busIDs.add(element);
          line1 = "Tap to select sanitization status";
          line2 = "Click on save to save sanitization status";
          // _operator_check.add(false);
        });
      });
    }
  }

  void updateBusStatus() {
    for (var i = 0; i < busIDs.length; i++) {
      ds.updateBusSanitizationStatus(busIDs[i], dateList[i]);
      print(dateList[i]);
    }
  }

  void datePicker(context, i) async {
    _select_date = await showDatePicker(
        context: context,
        initialDate: _current_date,
        firstDate: DateTime.now().subtract(Duration(days: 7)),
        lastDate: DateTime.now());
    setState(() {
      dateList[i] = _select_date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Sanitization"),
        backgroundColor: BusSanitization.backColor,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            height: 100,
            color: BusSanitization.backColor,
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: route,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Bus Route",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          // fontSize: 20,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 5),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.yellow,
                  textColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    getOperatorData();
                  },
                  child: Text(
                    "Search".toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 5),
          Text(line1, style: TextStyle(fontSize: 17)),
          Text(line2, style: TextStyle(fontSize: 17)),
          Expanded(
            child: ListView.builder(
              itemCount: busList.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text(
                      busList[i]["Number"],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      _current_date.difference(dateList[i]).inDays > 7 ? "Bus sanitization expired" : "",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    trailing: InkWell(
                      child: Text(DateFormat.yMMMd().format(dateList[i])),
                      onTap: () {
                        datePicker(context, i);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          updateBusStatus();
        },
        backgroundColor: BusSanitization.backColor,
      ),
    );
  }
}
