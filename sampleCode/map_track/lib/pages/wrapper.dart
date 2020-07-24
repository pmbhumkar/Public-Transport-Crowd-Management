import 'package:flutter/material.dart';
import 'package:maptrack/models/user.dart';
import 'package:maptrack/pages/driver.dart';
import 'package:maptrack/pages/login.dart';
import 'package:maptrack/pages/manager.dart';
import 'package:maptrack/pages/no_role.dart';
import 'package:maptrack/pages/search_landing.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    if (user != null) {
      print('Here');
      print(user.role);
    } else {
      print("No user");
    }
        // return either the Home or Authenticate widget
    if (user == null){
      return SearchLanding();
    } else if (user.role == 'driver') {
      // print("-----------------------------------");
      print(user.role);
      // print("-----------------------------------");
      return Driver();
    } else if (user.role == 'manager') {
      return ManagerPage();
    } else {
      return NoRole();
    }
  }
}
