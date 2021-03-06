import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:maptrack/models/bus.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference busCollection =
      Firestore.instance.collection("BusGeo");
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

  Future updateData(LocationData newLocation, busId) async {
    return await busCollection.document(busId).setData({
      "latlng": new GeoPoint(newLocation.latitude, newLocation.longitude),
      "accuracy": newLocation.accuracy,
      "heading": newLocation.heading
    });
  }

  Future<Map> getBusGeo(busId) async {
    return await busCollection
        .document(busId)
        .get()
        .then((value) => value.data);
  }

  Future<String> getUserName(userID) async {
    return await userCollection
        .document(userID)
        .get()
        .then((value) => value["name"]);
  }

  Future addBusStop(docName) async {
    return await busStop
        .document(docName)
        .setData({"latlng": new GeoPoint(18.564233, 73.776813), "skip": false});
  }

  Future<Map> getBusStopByName(busStopName) async {
    return await busStop
        .document(busStopName)
        .get()
        .then((value) => value.data);
  }

  updateBusStopHotspot(busStopName, status) async {
    await busStop.document(busStopName).updateData({"skip": status});
  }

  Future addBusRoute(docName, data) async {
    return await busRoute.document(docName).setData({
      "Name": data["Name"],
      "Route": data["Route"],
      "Source": data["Source"],
      "Destination": data["Destination"]
    });
  }

  void updateCountAtDest(busId, dest) async {
    var ref = busInfo.document(busId);
    ref.get().then((snapshot) {
      Map liveCount = Map.from(snapshot.data['LiveCount']);
      liveCount[dest] = liveCount[dest] + 1;

      ref.updateData({"LiveCount": liveCount});
    });
  }

  Future getBusRoute(routeID) async {
    return await busRoute.document(routeID).get().then((value) => value.data);
  }

  Future getCurrentScheduledRides(busID) async {
    var bsc = await busSchedule
        .where("BusId", isEqualTo: busID)
        .where("RideStarted", isEqualTo: true)
        .getDocuments();
    var scheduleInfo = bsc.documents;
    List scheduleData = [];
    scheduleInfo.forEach((element) {
      scheduleData.add(element.data);
    });
    return scheduleData;
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

  Future<Map> getBusOperatorByName(name) async {
    Map operatorData = {};
    var snapshot =
        await busOperator.where("Name", isEqualTo: name).getDocuments();
    var documents = snapshot.documents;
    documents.forEach((element) {
      operatorData[element.documentID] = element.data;
    });
    return operatorData;
  }

  updateBusOperatorHealth(userID, healthStatus) async {
    await busOperator
        .document(userID)
        .updateData({"HealthStatus": healthStatus});
  }

  updateBusSanitizationStatus(busID, status) async {
    await busInfo.document(busID).updateData({"LastSanitized": status});
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
    var bsd = await busRoute
        .where("Destination", isEqualTo: destination)
        .getDocuments();
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
    var binfo =
        await busInfo.where("BusRoute", isEqualTo: routeId).getDocuments();
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

  Future<Map> getBusInfoFromId(busId) async {
    Map busData = {};
    await busInfo.document(busId).get().then((value) {
      busData = value.data;
    });
    return busData;
  }

  Future<String> getUserRole(userID) async {
    // print(uid);
    return await userCollection
        .document(userID)
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

  Future<Map> getRidesByDateAndOperator(DateTime date, opId) async {
    var binfo =
        await busSchedule.where("OperatorId", isEqualTo: opId).getDocuments();
    var snap = binfo.documents;
    var busRides = await busInfo.getDocuments();
    var busSnap = busRides.documents;

    // var busList = [];
    // List busIDs = [];
    Map busData = {};
    snap.forEach((element) {
      String docDate =
          DateFormat('yyyy-MM-dd').format(element.data["DateTime"].toDate());
      String selectedDate = DateFormat('yyyy-MM-dd').format(date);

      if (docDate == selectedDate) {
        busData[element.documentID] = element.data;
        print(docDate);
        busSnap.forEach((elementinside) {
          if (elementinside.documentID == element.data["BusId"]) {
            print("enter");
            busData[element.documentID]["Route"] =
                elementinside.data["BusRoute"];
            busData[element.documentID]["Vehicle number"] =
                elementinside.data["Number"];
          }
        });
        // busIDs.add(element.documentID);
        // busList.add(element.data);
      }
    });
    // busData["busList"] = busList;
    // busData["busIDs"] = busIDs;
    //print(busData);
    return busData;
  }

  Future<Map> getBusInfo(String busId) async {
    Map busData = {};
    var binfo = await busInfo.document(busId).get();

    // var busList = [];
    // List busIDs = [];

    busData = binfo.data;

    return busData;
  }

  Future getRouteByBusId(String busId) async {
    print("Enter get routes");
    print(busId);
    Map busData = {};
    var binfo = await busRoute.document(busId).get();

    // var busList = [];
    // List busIDs = [];

    busData = binfo.data;
    print(busData);
    return busData;
  }

  Future checkIfSkip(stop) async {
    Map stopData = {};
    var stopinfo = await busStop.document(stop).get();

    stopData = stopinfo.data;
    print(stopData);
    return (stopData);
  }

  Future<Map> getDriverInfoById(driverId) async {
    Map driverData = {};
    var driverInfo = await busOperator.document(driverId).get();

    driverData = driverInfo.data;
    print(driverData);
    return (driverData);
  }

  Future<List> getBusRoutes() async {
    List<String> routeData = [];
    var routeInfo = await busInfo.getDocuments();
    var snap = routeInfo.documents;

    snap.forEach((element) {
      routeData.add(element.data["BusRoute"]);
    });

    routeData = routeData.toSet().toList();
    return routeData;
  }
}
