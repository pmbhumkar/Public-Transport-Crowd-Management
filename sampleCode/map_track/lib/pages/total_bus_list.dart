import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptrack/models/bus.dart';
import 'package:maptrack/services/database.dart';

class TotalBusList extends StatefulWidget {
  @override
  _TotalBusListState createState() => _TotalBusListState();
}

class _TotalBusListState extends State<TotalBusList> {
  static Timestamp ts = Timestamp.now();
  DatabaseService d = DatabaseService();
  static Random random = Random();
  List<String> bs = [
    "Westend",
    "Parihar Chowk",
    "Pimpri",
    "KothrudDepot",
    "Deccan",
    "PMC",
    "Swarget",
    "Katraj",
    "BhaktiShakti"
  ];
  List<String> first = [
    'Sindy',
    'Ivana',
    'Latia',
    'Eula',
    'Coretta',
    'Shanon',
    'Iraida',
    'Lessie',
    'Mickie',
    'Mohamed',
    'Gillian',
    'Malika',
    'Zita',
    'Candelaria',
    'Donn',
    'Charlette',
    'Odette',
    'Brandy',
    'Evelina',
    'Miriam'
  ];
  List<String> last = [
    'Racine',
    'Amore',
    'Neisler',
    'Bessler',
    'Betancourt',
    'Schmaltz',
    'Beede',
    'Kittel',
    'Scheid',
    'Mcwhirter',
    'Kysar',
    'Langford',
    'Elvira',
    'Wishon',
    'Bransford',
    'Banfield',
    'Kangas',
    'Messick',
    'Cravey',
    'Nowak'
  ];
  List<String> busId = [
    "JtQTBiuFGXgPhPqg1Pjm",
    "NcVUwNh1GqxbUIPGr7Ja",
    "ZZdDE1ZdoOOMeVYg4g8q",
    "bZUm5O2W4AYM9Vtlzx4u",
    "e91Egonc3mZqhcTRVLL4",
    "qRdhih3uq9Kv5wVoCcpW",
    "x3QcpmxV8OUGawLiCHhR"
  ];

  List<String> operatorId = [
    "0nARJSHRrCcvxplhxfEm",
    "4IdirwLGdmaeqNqwALui",
    "FZnrvr3nVgtcTJtejHA1",
    "MjHkVVSfKz34V0f2VsuQ",
    "TXigMSrokpn9LQBer43Q",
    "U8d5rYOKb4FykiggayNh",
    "U8d5rYOKb4FykiggayNh",
    "U8d5rYOKb4FykiggayNh"
  ];

  
  var routes = [
    {
      "Name": "Kothrud-PMC",
      "Route": ["KothrudDepot", "Deccan", "PMC"],
      "Source": "KothrudDepot",
      "Destination": "PMC"
    },
    {
      "Name": "Kothrud-Katraj",
      "Route": ["KothrudDepot", "Deccan", "Swarget" "Katraj"],
      "Source": "KothrudDepot",
      "Destination": "Katraj"
    },
    {
      "Name": "Kothrud-Nigdi",
      "Route": [
        "KothrudDepot",
        "Deccan",
        "Shivajinagar",
        "Pimpri",
        "BhaktiShakti"
      ],
      "Source": "KothrudDepot",
      "Destination": "BhaktiShakti"
    },
    {
      "Name": "Medipoint-PMC",
      "Route": ["Medipoint", "Aundh", "Parihar Chowk", "Shivajinagar", "PMC"],
      "Source": "Medipoint",
      "Destination": "PMC"
    },
    {
      "Name": "Medipoint-Pimpri",
      "Route": ["Medipoint", "Westend", "Parihar Chowk", "Pimpri"],
      "Source": "Medipoint",
      "Destination": "Pimpri"
    },
    {
      "Name": "Pimpri-Deccan",
      "Route": ["Pimpri", "Shivajinagar", "PMC", "Deccan"],
      "Source": "Pimpri",
      "Destination": "Deccan"
    },
  ];

  List<bool> trueFalse = [true, false];

  void addAllBusInfo() {
    routes.forEach((element) {
      // print(element["Name"]);
      var rlist = {};
      List rele = element["Route"];
      // print(rele);
      rele.forEach((r) {
        // print(r);
        rlist[r] = random.nextInt(10) + 2;
      });
      var busInfo = {
        "BusRoute": element["Name"],
        "LastSanitized": ts,
        "Number": random.nextInt(997) + 2,
        "TotalSeats": 50,
        "PassengerCount": random.nextInt(40) + 5,
        "LiveCount": rlist,
      };
      // print(busInfo);
      d.addBusInfo(busInfo);
    });
  }

  void addAllBuses() {
    bs.forEach((element) {
      d.addBusStop(element);
    });
  }

  void addAllRoutes() {
    routes.forEach((element) {
      var routeId = random.nextInt(997) + 2;
      d.addBusRoute(routeId.toString(), element);
    });
  }

  void listRoutes() {
    d.listBusRoutes();
  }

  void addBusOperator() {
    busId.forEach((element) {
      var data = {
        "Name": first[random.nextInt(first.length)] +
            ' ' +
            last[random.nextInt(last.length)],
        "Address": bs[random.nextInt(bs.length)],
        "BusId": element,
        "HealthStatus": true
      };
      d.addBusOperator(data);
    });
  }

  void addBusSchedule() {
    for (var i = 0; i < busId.length; i++) {
      var data = {
        "OperatorId": operatorId[i],
        "DateTime": ts,
        "BusId": busId[i],
        "RideStarted": trueFalse[random.nextInt(2)]
      };
      d.addSchedule(data);
    }
  }

  void getBusRoutes() {
    
  }

  // void getBusLists() async {
  //   List busList = [];
  //   List routeIds = await d.getBusRoutesByDestination("PMC");
  //   print(routeIds);
  //   routeIds.forEach((routeId) async {
  //     busList += await d.getBusInfoFromRoutes(routeId);
  //   });
  //   print("Hey-------------");
  //   print(busList);
  // }

  @override
  Widget build(BuildContext context) {
    final busList = Provider.of<List<Bus>>(context);

    return ListView.builder(
        itemCount: busList.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            child: ListTile(
              title: Text(busList[i].busRoute),
              subtitle: Text(busList[i].number),
              onTap: () {
                // addAllRoutes();
                setState(() {
                  // addAllRoutes();
                  // getBusRoutes();
                  // getBusLists();
                  // listRoutes();
                  // addAllBusInfo();
                  // addBusOperator();
                  // addBusSchedule();
                  // busNumber = busList[i]["number"];
                  // print(busList[i].number);
                  // Pop this page
                });
              },
            ),
          );
        });
  }
}
