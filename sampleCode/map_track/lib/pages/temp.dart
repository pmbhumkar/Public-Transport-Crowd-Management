import 'package:flutter/material.dart';
import 'dart:async';

class TempTimer extends StatefulWidget {
  @override
  _TempTimerState createState() => _TempTimerState();
}

class _TempTimerState extends State<TempTimer> {
  static const d = Duration(seconds: 10);
  Timer _timer;
  bool once = false;
  
  void startTimer() {
    int counter = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      setState(() {
        if (counter > 0) {
          counter --;
          print(counter);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void init() {
    if (!once){
      startTimer();
      once = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: Center(
        child: Text("Hey"),
      ),
    );
  }
}