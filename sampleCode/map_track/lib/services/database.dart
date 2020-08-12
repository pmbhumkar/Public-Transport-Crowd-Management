import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:maptrack/models/bus.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference busCollection =
      Firestore.instance.collection("BusLocation");
  final CollectionReference userCollection =
      Firestore.instance.collection("Users");
  static final CollectionReference busInfo =
      Firestore.instance.collection("BusInfo");
  static final CollectionReference busStop =
      Firestore.instance.collection("BusStop");
  static final CollectionReference busRoute =
      Firestore.instance.collection("BusRoute");
  static final CollectionReference busOperator =
      Firestore.instance.collection("BusOperator");
  static final CollectionReference busSchedule =
      Firestore.instance.collection("ScheduledRides");

  Future updateData(LocationData newLocation) async {
    return await busCollection.document().setData({
      "latlng": new GeoPoint(newLocation.latitude, newLocation.longitude),
    });
  }

  Future addBusStop(docName) async {
    return await busStop
        .document(docName)
        .setData({"latlng": new GeoPoint(18.564233, 73.776813), "skip": false});
  }

  Future addBusRoute(docName, data) async {
    return await busRoute.document(docName).setData({
      "Name": data["Name"],
      "Route": data["Route"],
      "Source": data["Source"],
      "Destination": data["Destination"]
    });
  }

  Future<void> listBusRoutes() async {
    var ql = await busRoute.getDocuments();
    var snap = ql.documents;
    snap.forEach((element) {
      print(element.documentID);
    });
  }

  Future addBusInfo(data) async {
    // print("Reach here-------------------------------");
    print(data);
    return await busInfo.document().setData({
      "BusRoute": data["BusRoute"],
      "LastSanitized": data["LastSanitized"],
      "LiveCount": data["LiveCount"],
      "Number": data["Number"],
      "PassengerCount": data["PassengerCount"],
      "TotalSeats": data["TotalSeats"]
    });
  }

  Future addBusOperator(data) async {
    return await busOperator.document().setData({
      "Name": data["Name"],
      "Address": data["Address"],
      "BusId": data["BusId"],
      "HealthStatus": data["HealthStatus"]
    });
  }

  Future addSchedule(data) async {
    return await busSchedule.document().setData({
      "OperatorId": data["OperatorId"],
      "DateTime": data["DateTime"],
      "BusId": data["BusId"],
      "RideStarted": data["RideStarted"]
    });
  }

  Future getBusRoutesByDestination(destination) async {
    var bsd = await busRoute.where("Destination", isEqualTo: destination).getDocuments();
    var snap = bsd.documents;
    // print("Hey-------------------------");
    // print(snap);
    List<String> routeIDs = [];
    snap.forEach((element) {
      routeIDs.add(element.documentID);
    });
    return routeIDs;
  }

  Future<Map> getBusInfoFromRoutes(routeId) async {
    var binfo = await busInfo.where("BusRoute", isEqualTo: routeId).getDocuments();
    var snap = binfo.documents;
    // var busList = [];
    // List busIDs = [];
    Map busData = {};
    snap.forEach((element) {
      // print(element.data);
      busData[element.documentID] = element.data;
      // busIDs.add(element.documentID);
      // busList.add(element.data);
    });
    // busData["busList"] = busList;
    // busData["busIDs"] = busIDs;
    return busData;

  }

  Future<String> getUserRole() async {
    // print(uid);
    return await userCollection
        .document(uid)
        .get()
        .then((value) => value['role']);
  }

  List<Bus> _busListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Bus(
          number: doc.data["Number"],
          busRoute: doc.data["BusRoute"],
          lastSanitized: doc.data["LastSanitized"],
          totalSeats: doc.data["TotalSeats"],
          passengerCount: doc.data["PassengerSeats"],
          liveCount: doc.data["LiveCount"]);
    }).toList();
  }

  Stream<List<Bus>> get buses {
    return busInfo.snapshots().map(_busListFromSnapshot);
  }
}
