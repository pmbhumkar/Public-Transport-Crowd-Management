import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Tracker extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  GoogleMapController _controller;
  Location location = new Location();
  Circle circle;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  static final LatLng destination = new LatLng(18.5789595, 73.7380213);

  static final CameraPosition initPosition = CameraPosition(
//    target: LatLng(37.43296265331129, -122.08832357078792),
    target: LatLng(18.5204, 73.8567),
    zoom: 15,
  );

  // void getCurrentLocation() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _locationData = await location.getLocation();

  //   // location.onLocationChanged()
  // }

  // Future<void> goToCurrentLocation() async {
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //       target: LatLng(_locationData.latitude, _locationData.longitude),
  //       tilt: 0,
  //       zoom: 18)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initPosition,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        Positioned(
          top: 60,
          left: 10,
          child: Container(
            width: 150,
            height: 50,
            // color: Colors.grey,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(8.0),
              color: Colors.white,
            ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "Source",
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
          ),
        ),
        Positioned(
          top: 60,
          left: 170,
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
              child: TextField(
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "Destination",
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
          ),
        ),
        Positioned(
          top: 60,
          right: 10,
          child: Container(
            width: 50,
            height: 50,
            // color: Colors.grey,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: InkWell(
              child: Icon(
                Icons.search,
              ),
              )
          ),
        )
      ]),
    );
  }
}
