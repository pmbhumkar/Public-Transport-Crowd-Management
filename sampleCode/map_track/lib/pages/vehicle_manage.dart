import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maptrack/pages/total_bus_list.dart';
import 'package:provider/provider.dart';
import 'package:maptrack/services/database.dart';
import 'package:maptrack/models/bus.dart';

class VehicleManage extends StatefulWidget {
  @override
  _VehicleManageState createState() => _VehicleManageState();
}

class _VehicleManageState extends State<VehicleManage> {
  List<Map<String, String>> busList = [];
  String busNumber = "";

  void buildList() {
    setState(() {
      busList = [
        {
          "number": "MH-14 7537",
          "busRoute": "Katraj-Aundh",
        },
        {
          "number": "MH-12 7337",
          "busRoute": "Katraj-Kothrud Depot",
        },
        {
          "number": "MH-12 9237",
          "busRoute": "PMC-PCMC",
        },
        {
          "number": "MH-12 5345",
          "busRoute": "Nigdi-Katraj",
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // final busInfo = Provider.of<QuerySnapshot>(context);
    // print(busInfo);
    buildList();
    return StreamProvider<List<Bus>>.value(
      value: DatabaseService().buses,
          child: Scaffold(
        appBar: AppBar(
          title: Text("Vehicle Manager"),
          backgroundColor: Colors.grey[800],
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: TotalBusList()),
      ),
    );
  }
}
