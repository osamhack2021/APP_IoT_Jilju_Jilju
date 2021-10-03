import 'package:flutter/services.dart';

Future<String> readFileAsString(String fileName) {
  return rootBundle.loadString('assets/' + fileName);
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
}

String durationToString(Duration duration) {
  String str = duration.toString();
  return str.substring(0, str.indexOf('.'));
}
