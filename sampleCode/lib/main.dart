import 'package:flutter/material.dart';
import 'package:maptrack/pages/bus_track.dart';
import 'package:maptrack/pages/loc_tracker.dart';


void main() {
  runApp(MaterialApp(
//    debugShowCheckedModeBanner: false,
   initialRoute: '/busTrack',
    routes: {
      '/' : (context) => Tracker(),
      '/busTrack': (context) => BusTrack(),
    },
  ));
}