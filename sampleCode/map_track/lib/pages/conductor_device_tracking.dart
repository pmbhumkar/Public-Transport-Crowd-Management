import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../components/map_pin_pill.dart';
import '../models/pin_pill_info.dart';
import 'package:maptrack/services/database.dart';
import 'package:flutter/cupertino.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(19.0741058, 72.9080143);
const LatLng DEST_LOCATION = LatLng(19.1153798, 72.9091436);

class ConductorDeviceTracking extends StatefulWidget {
  ConductorDeviceTracking({Key key, this.busId}) : super(key: key);

  final String busId;
  @override
  State<StatefulWidget> createState() => ConductorDeviceTrackingState();
}

class ConductorDeviceTrackingState extends State<ConductorDeviceTracking> {
  List busInfo = [];
  List textPlaceholder = [
    "Route",
    "Vehicle Number",
    "Available seats",
    "Add passenger"
  ];
  List iconPlaceholder = [
    CupertinoIcons.location_solid,
    CupertinoIcons.bus,
    LineAwesomeIcons.users,
    CupertinoIcons.person_add_solid
  ];
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = '<API_KEY>';
  PolylineResult result;
  DatabaseService d = DatabaseService();
  bool once = false;
  String dropdownValue = 'One';
  List<String> destList = [];

  void initList() {
    setState(() {
      once = true;
    });
    buildList();
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(19.0741058, 72.9080143),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/bus_icon.jpg");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("bus"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("busloc"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
    setPolylines(newLocalData);
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  void setPolylines(LocationData newLocalData) async {
    polylinePoints = PolylinePoints();
    print(newLocalData.latitude);

    PolylineResult temp = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(newLocalData.latitude, newLocalData.longitude),
      PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
      travelMode: TravelMode.driving,
    );

    setState(() {
      result = temp;
      print(result.points);
    });

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 2, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  Future buildList() async {
    Map tempData = {};
    setState(() {
      busInfo = [];
    });

    tempData = await d.getBusInfo(widget.busId);
    setState(() {
      if (tempData.isNotEmpty) {
        busInfo = tempData.values.toList();
        // Check the bus schedule before adding to the li
      }
      //print(tempData);
    });
    buildRoutes();
    busInfo.insert(2, (busInfo[4] - busInfo[5]).toString());
    busInfo.insert(3, "Select from dropdown");
    print(busInfo.length);
  }

  void buildRoutes() async {
    print("Enter build routes");
    print(busInfo[0]);
    Map tempRoutes = {};
    List temp = [];
    setState(() {
      destList = [];
    });

    tempRoutes = await d.getRouteByBusId(busInfo[0]);
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
    dropdownValue = destList[0];
    print(destList);
  }

  void updateLiveCount(String newValue) async {
    await d.updateCountAtDest(widget.busId, newValue);
  }

  @override
  Widget build(BuildContext context) {
    if (once == false) {
      initList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your ride has started!"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            markers: Set.of((marker != null) ? [marker] : []),
            circles: Set.of((circle != null) ? [circle] : []),
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              expand: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        color: Colors.grey[200],
                        child: ListTile(
                            leading:
                                Icon(iconPlaceholder[i], color: Colors.black),
                            title: Text(
                              textPlaceholder[i],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              busInfo[i],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            trailing: i == 3
                                ? Container(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.blueAccent,
                                      ),
                                      onChanged: (String newValue) {
                                        updateLiveCount(newValue);
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: destList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : SizedBox.shrink()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
}
