import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jilju/home.dart';
import 'package:jilju/util.dart';

import 'model/jilju.dart';

class JiljuBarChart extends StatefulWidget {
  final List<List<Jilju>> _jiljuLists;
  final double maxY;
  JiljuBarChart(this._jiljuLists, {Key? key})
      : maxY = getMaxY(_jiljuLists),
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

  List<BarChartGroupData> get barGroups => widget._jiljuLists
      .asMap()
      .map(
        (idx, jiljuList) => MapEntry(
          idx,
          BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                y: Jilju.getSumOfDistance(jiljuList),
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
            DateTime dateTime = today().subtract(Duration(
                days: (widget._jiljuLists.length - 1) - value.toInt()));
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
        touchCallback: (event, response) {
          if (!event.isInterestedForInteractions ||
              response == null ||
              response.spot == null) {
            return;
          }
          context
              .findAncestorStateOfType<HomePageState>()!
              .updateBottomTexts(response.spot!.touchedBarGroupIndex);
        },
        handleBuiltInTouches: false,
      );
}

class JiljuLineChart extends StatefulWidget {
  final List<List<Jilju>> _jiljuLists;
  final double maxY;
  JiljuLineChart(this._jiljuLists, {Key? key})
      : maxY = getMaxY(_jiljuLists),
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
          spots: widget._jiljuLists
              .asMap()
              .map(
                (idx, jiljuList) => MapEntry(
                  idx,
                  FlSpot(idx.toDouble(), Jilju.getSumOfDistance(jiljuList)),
                ),
              )
              .values
              .toList(),
          colors: [Colors.lightBlueAccent, Colors.greenAccent],
          isCurved: true,
          dotData: FlDotData(show: false),
        ),
      ];

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            DateTime dateTime = today().subtract(Duration(
                days: (widget._jiljuLists.length - 1) - value.toInt()));
            return DateFormat('MM/dd').format(dateTime);
          },
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 10,
          ),
          interval: (widget._jiljuLists.length ~/ 5 + 1).toDouble(),
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

double getMaxY(List<List<Jilju>> jiljuLists) {
  return max(
      jiljuLists
              .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
              .reduce(max) +
          1,
      3);
}
