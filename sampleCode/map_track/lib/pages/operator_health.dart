import 'package:flutter/material.dart';
import 'package:maptrack/services/database.dart';

class OperatorHealth extends StatefulWidget {
  static final backColor = Colors.grey[800];

  @override
  _OperatorHealthState createState() => _OperatorHealthState();
}

class _OperatorHealthState extends State<OperatorHealth> {
  final name = TextEditingController(text: "");
  DatabaseService ds = DatabaseService();
  List operatorList = [];
  List operatorIDs = [];
  String line1 = "";
  String line2 = "";
  // List<bool> _operator_check = [];

  void getOperatorData() async {
    setState(() {
      operatorList = [];
      line1 = "";
      line2 = "";
    });
    if (name.text != "") {
      Map operators = await ds.getBusOperatorByName(name.text);
      setState(() {
        operators.keys.forEach((element) {
          operatorList.add(operators[element]);
          operatorIDs.add(element);
          line1 = "Tap to select health status";
          line2 = "Click on save to save health status";
          // _operator_check.add(false);
        });
      });
    }
  }

  void updateHealthStatus() {
    for (var i = 0; i < operatorIDs.length; i++) {
      ds.updateBusOperatorHealth(
          operatorIDs[i], operatorList[i]["HealthStatus"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Operator Health"),
        backgroundColor: OperatorHealth.backColor,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            height: 100,
            color: OperatorHealth.backColor,
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
                        hintText: "Operator name",
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
              itemCount: operatorList.length,
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  color: Colors.grey[200],
                  child: CheckboxListTile(
                    title: Text(
                      operatorList[i]["Name"],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(operatorList[i]["Address"]),
                    secondary: Text(
                      operatorList[i]["HealthStatus"] ? "Healthy" : "Unhealthy",
                      style: TextStyle(
                        color: operatorList[i]["HealthStatus"]
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    value: operatorList[i]["HealthStatus"],
                    onChanged: (newValue) {
                      setState(() {
                        operatorList[i]["HealthStatus"] = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  ),
                  // child: ListTile(
                  //   leading: Icon(Icons.account_circle),
                  //   title: Text(
                  //     operatorList[i]["Name"],
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  //   // subtitle: Text(destController.text),
                  //   trailing: Text(
                  //     operatorList[0]["HealthStatus"] ? "Healthy" : "Unhealthy",
                  //   ),
                  //   onTap: () {},
                  // ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          updateHealthStatus();
        },
        backgroundColor: OperatorHealth.backColor,
      ),
    );
  }
}
