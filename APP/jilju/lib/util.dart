import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
