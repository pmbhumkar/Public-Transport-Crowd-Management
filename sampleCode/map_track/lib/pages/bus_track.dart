import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptrack/services/database.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class BusTrack extends StatefulWidget {
  Map busData = {};
  String busId = "";
  Uint8List busImage;
  CameraPosition initPosition;
  BusTrack(
      {Key key,
      @required this.busData,
      this.busId,
      this.initPosition,
      this.busImage})
      : super(key: key);

  @override
  _BusTrackState createState() => _BusTrackState();
}

class _BusTrackState extends State<BusTrack> {
  List<Map<String, double>> testData = [
    {
      'lat': 18.5581123,
      'lng': 73.7799656,
    },
    {
      'lat': 18.564426,
      'lng': 73.775622,
    },
    {
      'lat': 18.564233,
      'lng': 73.776813,
    },
    {'lat': 18.563538, 'lng': 73.776714},
    {
      'lat': 18.562641,
      'lng': 73.776690,
    },
    {
      'lat': 18.561675,
      'lng': 73.776669,
    },
    {
      'lat': 18.561787,
      'lng': 73.775982,
    },
    {
      'lat': 18.561899,
      'lng': 73.775392,
    },
  ];

  GoogleMapController _controller;

  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  int counter = 0;
  // static DateTime ts = new DataTime.now()
  String busID = "";
  static Timestamp ts = Timestamp.now();
  static var date;
  static var dateString;
  Timer _timer;
  bool once = true;
  var ds = DatabaseService();
  Uint8List imageData;
  CameraPosition newPos;

  // this will hold the generated polylines
  LatLng source_place = LatLng(18.57098, 73.77297);
  Set<Polyline> _polylines =
      {}; // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates =
      []; // this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAnnBzNgoL_xOZ9yUfHE7oCOwuqNMcTdGE";
  PolylineResult result;
  Map busLocation = {};
  GeoPoint busGeoPoint;

  static Map currentBusData = {
    "BusRoute": "121",
    "Number": "MH-No number",
    "PassengerCount": 0,
    "TotalSeats": 50,
    "LastSanitized": ts
  };

  Map temp = {
    "Time to arrive at {BusStopName}": "19 min",
    "Bus Number": "7537",
    "Available Seats": "13",
    "Next Stoppage": "Baner",
    "Driver health status": "Healthy",
    "Bus sanitization status": "Last sanitized on 25th July",
    "Last update": "2 sec ago",
  };
  Map statusMap = {};

  void initilization() {
    // print("init");
    setState(() {
      currentBusData = widget.busData;
      date = DateTime.fromMicrosecondsSinceEpoch(
          currentBusData["LastSanitized"].microsecondsSinceEpoch);
      dateString = DateFormat().add_yMMMMd().format(date);
      busID = widget.busId;
      imageData = widget.busImage;
      // newPos = widget.initPosition;
      // print("------------------------------------");
      // print(currentBusData.keys);
      statusMap = {
        "Route number": currentBusData["BusRoute"],
        "Bus Number": currentBusData["Number"],
        "Available seats":
            (currentBusData["TotalSeats"] - currentBusData["PassengerCount"])
                .toString(),
        "Stanitization status": dateString.toString(),
        "Bus Operator health": "Healthy"
      };
    });
    if (once) {
      setState(() {
        newPos = widget.initPosition;
      });
      startTimer();
      once = false;
    }
  }

  void getBusLocation() async {}

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      if (busID != "") {
        print("fetching data from : " + busID);
        // ds.getBusGeo(busID);
        Map locdata = await ds.getBusGeo(busID);
        if (this.mounted) {
          setState(() {
            busGeoPoint = locdata["latlng"];
            busLocation["latitude"] = busGeoPoint.latitude;
            busLocation["longitude"] = busGeoPoint.longitude;
            busLocation["accuracy"] = locdata["accuracy"];
            busLocation["heading"] = locdata["heading"];
            newPos = new CameraPosition(
              target: LatLng(busLocation["latitude"], busLocation["longitude"]),
              zoom: 15,
            );
            // busLocation = LocationData(dataLoc);
          });
          updateMarkerAndCircle(busLocation, imageData);
        }

        
      }

      // setState(() {
      //   currentBusData = widget.busData;
      //   date = DateTime.fromMicrosecondsSinceEpoch(
      //       currentBusData["LastSanitized"].microsecondsSinceEpoch);
      //   dateString = DateFormat().add_yMMMMd().format(date);
      //   busID = widget.busId;
      //   // print("------------------------------------");
      //   // print(currentBusData.keys);
      // });
      // if (result != null) {
      //   print(result.points);
      // }
      // print(currentBusData);
    });
  }

  setPolylines(destination) async {
    result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(source_place.latitude, source_place.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving);
    print("After calling---------------------------------------");
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/bus_icon.jpg");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(Map newLocalData, Uint8List currentBusImage) {
    print("--------------------");
    print(imageData);
    LatLng latlng = LatLng(newLocalData["latitude"], newLocalData["longitude"]);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("bus"),
          position: latlng,
          rotation: newLocalData["heading"],
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("busloc"),
          radius: newLocalData["accuracy"],
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
    // setPolylines(newLocalData);
  }

  // void getLocation() async {
  //   Uint8List imageData = await getMarker();
  //   LocationData location = await _locationTracker.getLocation();

  //   // print("Getting data");

  //   // ds.updateData(location, busID);
  //   updateMarkerAndCircle(location, imageData);
  // }

  List<TableRow> _buildRow() {
    List<TableRow> tr = [];
    for (var key in statusMap.keys) {
      tr.add(TableRow(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(key),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(":  " + statusMap[key])),
        ],
      ));
    }
    return tr;
  }

  @override
  Widget build(BuildContext context) {
    initilization();
    // print("me");
    // getInitLocation();
    return Scaffold(
      body: SlidingUpPanel(
        panel: Container(
            color: Colors.grey[300],
            // child: Text("Hey"),
            child: Table(
              children: _buildRow(),
            )),
        // child: ListView.builder(
        //   itemCount: currentBusData.keys.length,
        //   itemBuilder: (context, i) {
        //     return ListTile(
        //       title: ,
        //     );
        //   },
        // ),
        // ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: newPos,
          myLocationEnabled: true,
          compassEnabled: true,
          markers: Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.location_searching),
      //     onPressed: () {
      //       getLocation();
      //     }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
