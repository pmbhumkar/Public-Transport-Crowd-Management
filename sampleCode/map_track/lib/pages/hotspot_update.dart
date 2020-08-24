import 'package:flutter/material.dart';
import 'package:maptrack/services/database.dart';

class HotSpotUpdate extends StatefulWidget {
  static final backColor = Colors.grey[800];

  @override
  _HotSpotUpdateState createState() => _HotSpotUpdateState();
}

class _HotSpotUpdateState extends State<HotSpotUpdate> {
  final name = TextEditingController(text: "");
  DatabaseService ds = DatabaseService();
  List busStopData = [];
  String line1 = "";
  String line2 = "";
  // List<bool> _operator_check = [];

  void getOperatorData() async {
    setState(() {
      busStopData = [];
      line1 = "";
      line2 = "";
    });
    if (name.text != "") {
      Map stopData = await ds.getBusStopByName(name.text);
      setState(() {
        busStopData.add(stopData);
        line1 = "Tick if the bus stop is a hotspot";
        line2 = "Click on save to save hotspot status";
      });
    }
  }

  void updateHotSpotStatus() {
    ds.updateBusStopHotspot(name.text, busStopData[0]["skip"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotspots"),
        backgroundColor: HotSpotUpdate.backColor,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            height: 100,
            color: HotSpotUpdate.backColor,
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
                    controller: name,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Bus stop name",
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
              itemCount: busStopData.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  color: Colors.grey[200],
                  child: CheckboxListTile(
                    title: Text(
                      name.text,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      busStopData[0]["skip"] ? "It is a hotspot" : "",
                      style: TextStyle(color: Colors.red),
                    ),
                    value: busStopData[0]["skip"],
                    onChanged: (newValue) {
                      setState(() {
                        busStopData[0]["skip"] = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.red,
                    checkColor: Colors.white,
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
          updateHotSpotStatus();
        },
        backgroundColor: HotSpotUpdate.backColor,
      ),
    );
  }
}
