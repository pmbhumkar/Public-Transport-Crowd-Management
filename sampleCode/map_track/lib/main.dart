import 'package:flutter/material.dart';
import 'package:maptrack/models/user.dart';
import 'package:maptrack/pages/wrapper.dart';
import 'package:maptrack/services/auth.dart';
import 'package:provider/provider.dart';
// import 'package:maptrack/pages/bus_track.dart';
// import 'package:maptrack/pages/driver.dart';
// import 'package:maptrack/pages/loc_tracker.dart';
// import 'package:maptrack/pages/login.dart';
// import 'package:maptrack/pages/search_landing.dart';
// import 'package:maptrack/pages/bus_time_view.dart';



// void main() {
//   runApp(MaterialApp(
// //    debugShowCheckedModeBanner: false,
//   //  initialRoute: '/login',
//     // routes: {
//     //   '/' : (context) => SearchLanding(),
//     //   '/busTrack': (context) => BusTrack(),
//     //   '/search': (context) => SearchLanding(),
//     //   '/busTime': (context) => BusTimeList(),
//     //   '/login': (context) => LoginPage(),
//     //   '/driver': (context) => Driver(),
//     // },

//   ));
// }

void main() {
  runApp(MyApp());
  }
  
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

