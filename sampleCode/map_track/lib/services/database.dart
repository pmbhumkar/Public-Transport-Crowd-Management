import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference busCollection =
      Firestore.instance.collection("BusLocation");
  final CollectionReference userCollection =
      Firestore.instance.collection("Users");

  Future updateData(LocationData newLocation) async {
    return await busCollection.document().setData({
      "latlng": new GeoPoint(newLocation.latitude, newLocation.longitude),
    });
  }

  Future<String> getUserRole() async {
    // print(uid);
    return await userCollection.document(uid).get().then((value) => value['role']
    );
  }
}
