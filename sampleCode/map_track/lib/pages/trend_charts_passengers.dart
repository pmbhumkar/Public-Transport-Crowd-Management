import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class BarGraphPassengers extends StatefulWidget {
  BarGraphPassengers({Key key}) : super(key: key);

  @override
  _BarGraphPassengersState createState() => _BarGraphPassengersState();
}

class _BarGraphPassengersState extends State<BarGraphPassengers> {
  List<NumberOfpassengers> data;
  @override
  void initState() {
    super.initState();
    data = [
      NumberOfpassengers(
        month: 'June',
        count: 50,
        barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
      ),
      NumberOfpassengers(
        month: 'July',
        count: 15,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      NumberOfpassengers(
        month: 'August',
        count: 28,
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger trends'),
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
                'Number of passengers violating health and safety protocols per month',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberOfpassengers {
  final String month;
  final double count;
  final charts.Color barColor;

  NumberOfpassengers({
    @required this.month,
    @required this.count,
    @required this.barColor,
  });
}

class MyBarChart extends StatelessWidget {
  final List<NumberOfpassengers> data;

  MyBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<NumberOfpassengers, String>> series = [
      charts.Series(
          id: 'NumberOfpassengers',
          data: data,
          domainFn: (NumberOfpassengers passengers, _) => passengers.month,
          measureFn: (NumberOfpassengers passengers, _) => passengers.count,
          colorFn: (NumberOfpassengers passengers, _) => passengers.barColor)
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}