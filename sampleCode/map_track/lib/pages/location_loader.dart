import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptrack/pages/bus_track.dart';
import 'package:maptrack/services/database.dart';
import 'dart:typed_data';

class LocationLoader extends StatelessWidget {
  String busId;
  LocationLoader({Key key, @required this.busId}) : super(key: key);
  DatabaseService d = DatabaseService();

  Location _locationTracker = Location();
  CameraPosition initPosition;
  Map<String, dynamic> busDataToPass = {};

  Future<Uint8List> getMarker(context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/bus_icon.jpg");
    return byteData.buffer.asUint8List();
  }

  void getInitLocation(BuildContext context) async {
    LocationData location = await _locationTracker.getLocation();
    busDataToPass = await d.getBusInfoFromId(busId);
    Uint8List imageData = await getMarker(context);
    // getBusData(busId);
    initPosition = new CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 15,
    );
    // print(initPosition);
    // print(busDataToPass);
    while (true) {
      if (busDataToPass != {}) {
        print(busDataToPass);
        break;
      }
    }
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BusTrack(
          busData: busDataToPass,
          busId: busId,
          initPosition: initPosition,
          busImage: imageData),
    ));
  }

  @override
  Widget build(BuildContext context) {
    getInitLocation(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
      )),
    );
  }
}
