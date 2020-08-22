import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptrack/pages/bus_track.dart';
import 'package:maptrack/services/database.dart';

class LocationLoader extends StatelessWidget {
  String busId;
  LocationLoader({Key key, @required this.busId}) : super(key: key);
  DatabaseService d = DatabaseService();

  Location _locationTracker = Location();
  CameraPosition initPosition;


  void getInitLocation(BuildContext context) async {
    LocationData location = await _locationTracker.getLocation();
    Map<String, dynamic> busDataToPass = await d.getBusInfoFromId(busId);
    // getBusData(busId);
    initPosition = new CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 15,
    );
    print(initPosition);
    print(busDataToPass);

    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BusTrack(busData: busDataToPass, busId: busId, initPosition: initPosition),
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
