import 'package:flutter/material.dart';
import 'package:maptrack/models/user.dart';
import 'package:maptrack/pages/bus_time_view.dart';
import 'package:maptrack/pages/bus_track.dart';
import 'package:maptrack/pages/driver.dart';
import 'package:maptrack/pages/location_loader.dart';
import 'package:maptrack/pages/login.dart';
import 'package:maptrack/pages/manager.dart';
import 'package:maptrack/pages/no_role.dart';
import 'package:maptrack/pages/operator_health.dart';
import 'package:maptrack/pages/hotspot_update.dart';
import 'package:maptrack/pages/bus_sanitization.dart';
import 'package:maptrack/pages/sanitization_form.dart';
import 'package:maptrack/pages/search_landing.dart';
import 'package:maptrack/pages/temp.dart';
import 'package:maptrack/pages/vehicle_manage.dart';
import 'package:provider/provider.dart';
import 'package:maptrack/services/database.dart';
import 'package:maptrack/pages/conductor_schedule.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  DatabaseService d = DatabaseService();
  String userRole = "";
  bool roleCheck = true;

  void getUserRole(userID) async {
    String role = await d.getUserRole(userID);
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
     if (user != null) {
       if (roleCheck) {
         getUserRole(user.uid);
         print(userRole);
         setState(() {
          roleCheck = false;
        });
      }
    }

    if (user == null) {
      setState(() {
        roleCheck = true;
      });
      return SearchLanding();
    } else {
      if (userRole == "manager") {
        return ManagerPage();
      } else if (userRole == "driver") {
        return Schedule(userID: user.uid);
      }
      return SearchLanding();
    }

    // return LoginPage();
    // return SearchLanding();
  }
}

