import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class BarGraphBuses extends StatefulWidget {
  BarGraphBuses({Key key}) : super(key: key);

  @override
  _BarGraphBusesState createState() => _BarGraphBusesState();
}

class _BarGraphBusesState extends State<BarGraphBuses> {
  List<NumberOfbuses> data;
  @override
  void initState() {
    super.initState();
    data = [
      NumberOfbuses(
        month: 'June',
        count: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.orange),
      ),
      NumberOfbuses(
        month: 'July',
        count: 40,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      NumberOfbuses(
        month: 'August',
        count: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Sanitization trends'),
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
                'Lapse in sanitization per month',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberOfbuses {
  final String month;
  final double count;
  final charts.Color barColor;

  NumberOfbuses({
    @required this.month,
    @required this.count,
    @required this.barColor,
  });
}

class MyBarChart extends StatelessWidget {
  final List<NumberOfbuses> data;

  MyBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<NumberOfbuses, String>> series = [
      charts.Series(
          id: 'NumberOfbuses',
          data: data,
          domainFn: (NumberOfbuses buses, _) => buses.month,
          measureFn: (NumberOfbuses buses, _) => buses.count,
          colorFn: (NumberOfbuses buses, _) => buses.barColor)
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}