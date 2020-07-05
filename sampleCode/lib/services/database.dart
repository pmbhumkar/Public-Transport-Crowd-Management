import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class DatabaseService {
  

  final CollectionReference busCollection = Firestore.instance.collection("BusLocation");

  Future updateData(LocationData newLocation) async {
    return await busCollection.document().setData({
      "latlng": new GeoPoint(newLocation.latitude, newLocation.longitude),
    });
  }
}