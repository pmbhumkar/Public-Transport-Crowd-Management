import 'package:flutter/material.dart';
import 'package:maptrack/pages/bus_track.dart';

class BusTimeList extends StatefulWidget {
  static final backColor = Colors.grey[800];
  String destination = "";
  BusTimeList({Key key, @required this.destination}) : super(key: key);

  @override
  _BusTimeListState createState() => _BusTimeListState();
}

class _BusTimeListState extends State<BusTimeList> {
  String deptValue = "Depart Now";
  // String dest = BusTimeList.destination;
  List<Map<String, String>> busList = [];
  final source = TextEditingController(text: "");
  final destController = TextEditingController(text: "");

  void initDestination() {
    setState(() {
      destController.text = widget.destination;
    });
  }

  Future buildList() async {
    setState(() {
      widget.destination = destController.text;
      if (destController.text != "") {
        busList = [
          {"number": "123", "duration": "19 min", "busStop": "Aundh Bus Stop"},
          {"number": "101", "duration": "15 min", "busStop": "Medipoint"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
          {"number": "218", "duration": "27 min", "busStop": "Parihar Chowk"},
        ];
      } else {
        busList = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initDestination();
    return Scaffold(
      appBar: AppBar(
        title: Text("Routes"),
        backgroundColor: BusTimeList.backColor,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Container(
            height: 200,
            color: BusTimeList.backColor,
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
                    controller: source,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Your Current Location",
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
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: destController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Destination",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          // fontSize: 20,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 60, right: 50, top: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: deptValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    dropdownColor: Colors.grey[900],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    items: <String>[
                      'Depart Now',
                      'Set Departure Time',
                      'Set Arrival Time',
                      'Last lines for today'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        deptValue = newValue;
                      });
                    },
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
                    buildList();
                  },
                  child: Text(
                    "Find Routes".toUpperCase(),
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
      body: ListView.builder(
        itemCount: busList.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(Icons.directions_bus),
              title: Text(
                busList[i]["number"],
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(busList[i]["busStop"] + ' / ' + busList[i]["duration"]),
              trailing:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  Text('Avail - 20'),
                  Text('Psgr - 35')
                ]
              ),
              onTap: () {
                // Navigator.pushNamed(context, '/busTrack');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        BusTrack(),
                  ));
              },
            ),
          );
        },
      ),
    );
  }
}
