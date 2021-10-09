import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'model/jilju.dart';

class JiljuBarChart extends StatefulWidget {
  final Map<DateTime, List<Jilju>> _jiljuMap;
  final void Function(FlTouchEvent, BarTouchResponse?)? _touchCallback;
  final double maxY;
  JiljuBarChart(this._jiljuMap, this._touchCallback, {Key? key})
      : maxY = getMaxY(_jiljuMap),
        super(key: key);

  @override
  State<JiljuBarChart> createState() => _JiljuBarChartState();
}

class _JiljuBarChartState extends State<JiljuBarChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        titlesData: titlesData,
        barTouchData: barTouchData,
        maxY: widget.maxY,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<BarChartGroupData> get barGroups => widget._jiljuMap.keys
      .toList()
      .asMap()
      .map(
        (idx, dateTime) => MapEntry(
          idx,
          BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                y: Jilju.getSumOfDistance(widget._jiljuMap[dateTime]!),
                colors: [Colors.lightBlueAccent, Colors.greenAccent],
                width: 20,
              )
            ],
          ),
        ),
      )
      .values
      .toList();

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            DateTime dateTime = widget._jiljuMap.keys.toList()[value.toInt()];
            return DateFormat('MM/dd').format(dateTime);
          },
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 10,
          ),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 10,
          ),
          interval: (max(widget.maxY - 1, 0) ~/ 5 + 1).toDouble(),
          margin: 20,
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchCallback: widget._touchCallback,
        handleBuiltInTouches: false,
      );
}

class JiljuLineChart extends StatefulWidget {
  final Map<DateTime, List<Jilju>> _jiljuMap;
  final double maxY;
  JiljuLineChart(this._jiljuMap, {Key? key})
      : maxY = getMaxY(_jiljuMap),
        super(key: key);

  @override
  State<JiljuLineChart> createState() => _JiljuLineChartState();
}

class _JiljuLineChartState extends State<JiljuLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: titlesData,
        lineTouchData: LineTouchData(enabled: false),
        maxY: widget.maxY,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<LineChartBarData> get lineBarsData => [
        LineChartBarData(
          spots: widget._jiljuMap.keys
              .toList()
              .asMap()
              .map(
                (idx, dateTime) => MapEntry(
                  idx,
                  FlSpot(idx.toDouble(),
                      Jilju.getSumOfDistance(widget._jiljuMap[dateTime]!)),
                ),
              )
              .values
              .toList(),
          colors: [Colors.lightBlueAccent, Colors.greenAccent],
          isCurved: true,
          preventCurveOverShooting: true,
          dotData: FlDotData(show: false),
        ),
      ];

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            DateTime dateTime = widget._jiljuMap.keys.toList()[value.toInt()];
            return DateFormat('MM/dd').format(dateTime);
          },
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 10,
          ),
          interval: (widget._jiljuMap.length ~/ 5 + 1).toDouble(),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 10,
          ),
          interval: (max(widget.maxY - 1, 0) ~/ 5 + 1).toDouble(),
          margin: 30,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );
}

double getMaxY(Map<DateTime, List<Jilju>> jiljuMap) {
  return max(
      jiljuMap.values
              .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
              .reduce(max) +
          1,
      3);
}
