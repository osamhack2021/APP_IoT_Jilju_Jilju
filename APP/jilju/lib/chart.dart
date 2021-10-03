import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jilju/home.dart';
import 'package:jilju/util.dart';

import 'model/jilju.dart';

class Chart extends StatefulWidget {
  final List<List<Jilju>> jiljuLists;
  late final double maxY;
  Chart(this.jiljuLists, {Key? key}) : super(key: key) {
    maxY = max(
        jiljuLists
                .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
                .reduce(max) +
            1,
        3);
  }

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        titlesData: titlesData,
        barTouchData: barTouchData,
        maxY: widget.maxY,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

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

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) {
            DateTime dateTime = today().subtract(
                Duration(days: (widget.jiljuLists.length - 1) - value.toInt()));
            return DateFormat('MM/dd').format(dateTime);
          },
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 20,
          ),
          margin: 20,
          interval: (((widget.jiljuLists.length - 1) ~/ 7) + 1).toDouble(),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 20,
          ),
          margin: 20,
          interval: ((max(widget.maxY - 1, 0) ~/ 5) + 1).toDouble(),
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  List<BarChartGroupData> get barGroups => widget.jiljuLists
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
}
