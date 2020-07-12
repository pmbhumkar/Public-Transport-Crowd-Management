import 'package:flutter/material.dart';
import 'package:maptrack/pages/bus_track.dart';
import 'package:maptrack/pages/loc_tracker.dart';
import 'package:maptrack/pages/login.dart';
import 'package:maptrack/pages/search_landing.dart';
import 'package:maptrack/pages/bus_time_view.dart';


void main() {
  runApp(MaterialApp(
//    debugShowCheckedModeBanner: false,
  //  initialRoute: '/busTime',
    routes: {
      '/' : (context) => SearchLanding(),
      '/busTrack': (context) => BusTrack(),
      '/search': (context) => SearchLanding(),
      '/busTime': (context) => BusTimeList(),
      '/login': (context) => LoginPage(),
    },
  ));
}