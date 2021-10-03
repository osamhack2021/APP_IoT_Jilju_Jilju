import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jilju/util.dart';

import 'model/jilju.dart';

class Chart extends StatelessWidget {
  final List<List<Jilju>> jiljuLists;
  late final double maxDistance;
  Chart(this.jiljuLists, {Key? key}) : super(key: key) {
    maxDistance = max(
        jiljuLists
            .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
            .reduce(max),
        3);
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        titlesData: titlesData,
        barTouchData: barTouchData,
        maxY: maxDistance,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) {
            DateTime dateTime = today().subtract(
                Duration(days: (jiljuLists.length - 1) - value.toInt()));
            return DateFormat('MM/dd').format(dateTime);
          },
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 20,
          ),
          margin: 20,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontSize: 20,
          ),
          margin: 20,
          interval: max((maxDistance ~/ 5).toDouble(), 1),
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  List<BarChartGroupData> get barGroups => jiljuLists
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
