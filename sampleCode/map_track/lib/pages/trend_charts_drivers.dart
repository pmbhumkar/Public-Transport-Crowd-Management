import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class BarGraphDrivers extends StatefulWidget {
  BarGraphDrivers({Key key}) : super(key: key);

  @override
  _BarGraphDriversState createState() => _BarGraphDriversState();
}

class _BarGraphDriversState extends State<BarGraphDrivers> {
  List<NumberOfDrivers> data;
  @override
  void initState() {
    super.initState();
    data = [
      NumberOfDrivers(
        month: 'June',
        count: 15,
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
      NumberOfDrivers(
        month: 'July',
        count: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      NumberOfDrivers(
        month: 'August',
        count: 10,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver trends'),
        backgroundColor:Colors.grey[800]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Card(
              child: MyBarChart(data),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Number of drivers violating health and safety protocols per month',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberOfDrivers {
  final String month;
  final double count;
  final charts.Color barColor;

  NumberOfDrivers({
    @required this.month,
    @required this.count,
    @required this.barColor,
  });
}

class MyBarChart extends StatelessWidget {
  final List<NumberOfDrivers> data;

  MyBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<NumberOfDrivers, String>> series = [
      charts.Series(
          id: 'NumberOfDrivers',
          data: data,
          domainFn: (NumberOfDrivers drivers, _) => drivers.month,
          measureFn: (NumberOfDrivers drivers, _) => drivers.count,
          colorFn: (NumberOfDrivers drivers, _) => drivers.barColor)
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}