import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartRoutes extends StatefulWidget {
  @override
  _PieChartRoutesState createState() => _PieChartRoutesState();
}

class _PieChartRoutesState extends State<PieChartRoutes> {
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Route-685", () => 5);
    dataMap.putIfAbsent("Route-222", () => 2);
    dataMap.putIfAbsent("Route-875", () => 7);
    dataMap.putIfAbsent("Route-124", () => 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route wise trends"),
        backgroundColor:Colors.grey[800]
      ),
      body: Stack(children:<Widget>[
        Text(
              'Route wise trend of violation of protocols in the current month',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
        Container(
         child: Center(
         child: PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery.of(context).size.width,
                  showChartValuesInPercentage: false,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.grey[200],
                  colorList: colorList,
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  decimalPlaces: 1,
                  showChartValueLabel: true,
                  initialAngle: 0,
                  chartValueStyle: defaultChartValueStyle.copyWith(
                    color: Colors.blueGrey[900].withOpacity(0.9),
                  ),
                  chartType: ChartType.disc,
                ),   
              ), 
            ),
            
        ], 
      ),     
    );
  }
}