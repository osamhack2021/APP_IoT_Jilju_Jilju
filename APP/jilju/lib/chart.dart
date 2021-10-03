import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jilju/home.dart';
import 'package:jilju/util.dart';

import 'model/jilju.dart';

class JiljuBarChart extends StatefulWidget {
  final List<List<Jilju>> _jiljuLists;
  late final double maxY;
  JiljuBarChart(this._jiljuLists, {Key? key}) : super(key: key) {
    maxY = max(
        _jiljuLists
                .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
                .reduce(max) +
            1,
        3);
  }

  @override
  State<JiljuBarChart> createState() => _JiljuBarChartState();
}

class _JiljuBarChartState extends State<JiljuBarChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceAround,
          titlesData: titlesData,
          barTouchData: barTouchData,
          maxY: widget.maxY,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
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
          getTitles: (double value) {
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
          interval: ((max(widget.maxY - 1, 0) ~/ 5) + 1).toDouble(),
          margin: 10,
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
  late final double maxY;
  JiljuLineChart(this._jiljuLists, {Key? key}) : super(key: key) {
    maxY = max(
        _jiljuLists
                .map((jiljuList) => Jilju.getSumOfDistance(jiljuList))
                .reduce(max) +
            1,
        3);
  }

  @override
  State<JiljuLineChart> createState() => _JiljuLineChartState();
}

class _JiljuLineChartState extends State<JiljuLineChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LineChart(
        LineChartData(
          lineBarsData: lineBarsData,
          titlesData: titlesData,
          lineTouchData: lineTouchData,
          maxY: widget.maxY,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
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
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 3,
              color: lerpGradient(
                  barData.colors, barData.colorStops, percent / 100),
              strokeColor: lerpGradient(
                  barData.colors, barData.colorStops, percent / 100),
            ),
          ),
        ),
      ];

  Color lerpGradient(List<Color> colors, List<double>? stops, double t) {
    if (colors.length == 1) {
      return colors[0];
    }
    if (stops == null || stops.length != colors.length) {
      stops = [];
      colors.asMap().forEach((index, color) {
        final percent = 1.0 / (colors.length - 1);
        stops!.add(percent * index);
      });
    }
    for (var s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s], rightStop = stops[s + 1];
      final leftColor = colors[s], rightColor = colors[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT)!;
      }
    }
    return colors.last;
  }

  LineTouchData get lineTouchData => LineTouchData(
        enabled: true,
        touchCallback: (event, response) {
          if (!event.isInterestedForInteractions ||
              response == null ||
              response.lineBarSpots == null) {
            return;
          }
          context
              .findAncestorStateOfType<HomePageState>()!
              .updateBottomTexts(response.lineBarSpots![0].spotIndex);
        },
        handleBuiltInTouches: false,
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTitles: (double value) {
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
          interval: ((max(widget.maxY - 1, 0) ~/ 5) + 1).toDouble(),
          margin: 30,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );
}
