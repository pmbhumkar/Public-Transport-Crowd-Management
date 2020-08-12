import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  final int number;
  final String busRoute;
  final Timestamp lastSanitized;
  final int totalSeats;
  final int passengerCount;
  var liveCount;

  Bus({
    this.number,
    this.busRoute,
    this.lastSanitized,
    this.totalSeats,
    this.passengerCount,
    this.liveCount
  });
}