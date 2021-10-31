import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'indicator.dart';

const defaultUserWeight = 60;

Future<String> readFileAsString(String fileName) {
  return rootBundle.loadString('assets/' + fileName);
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
}

String dateToString(DateTime date) {
  return DateFormat('yyyy/MM/dd').format(date);
}

String timeToString(DateTime time) {
  return DateFormat('HH:mm').format(time);
}

String durationToString(Duration duration) {
  String str = duration.toString();
  return str.substring(0, str.indexOf('.'));
}

DateTime secondsToDateTime(int secondsSinceEpoch) {
  return DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
}

double speedToMet(double speed) {
  return 1.138 * speed - 1.98;
}

/// weight (kg), speed (km/h), time (min)
double caloriesBurned(int weight, double speed, int time) {
  return 3.5 * speedToMet(speed) * weight * time / 1000 * 5;
}

void setProgressVisible(BuildContext context, bool visible) {
  if (visible) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IndicatorPage(),
      ),
    );
  } else {
    Navigator.pop(context);
  }
}
