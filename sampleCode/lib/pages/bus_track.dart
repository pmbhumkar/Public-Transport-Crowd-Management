import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptrack/services/database.dart';

class BusTrack extends StatefulWidget {
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
    {
      'lat': 18.563538, 
      'lng': 73.776714
    },
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
  }

  void getLocation() async {
    Uint8List imageData = await getMarker();
    LocationData location = await _locationTracker.getLocation();
    // print(location.latitude);
    // print(location.longitude);
    // print(location.accuracy);
    // print(location.altitude);
    // print(location.heading);
    // print(location.hashCode);
    // print(location.speed);
    // print(location.speedAccuracy);
    // if (counter < testData.length) {
    //   var sample = testData[counter];
    //   LocationData newLoc = new LocationData.fromMap(
    //       {'latitude': sample["lat"], 'longitude': sample["lng"]});

    // }
    var d = DatabaseService();
    d.updateData(location);
    updateMarkerAndCircle(location, imageData);
  }


  static final CameraPosition initPosition = CameraPosition(
    target: LatLng(18.5204, 73.8567),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    // continueCall();
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initPosition,
        myLocationEnabled: true,
        compassEnabled: true,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getLocation();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
