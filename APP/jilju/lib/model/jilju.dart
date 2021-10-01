import 'package:hive_flutter/hive_flutter.dart';

import 'jilju_point.dart';

part 'jilju.g.dart';

@HiveType(typeId: 0)
class Jilju extends HiveObject {
  @HiveField(0)
  int startTime;

  @HiveField(1)
  int endTime;

  @HiveField(2)
  double distance;

  @HiveField(3)
  List<JiljuPoint> points;

  Jilju(this.startTime)
      : endTime = startTime,
        distance = 0,
        points = [JiljuPoint(0, 0, 0)];

  /// Add a new JiljuPoint. The time of the new JiljuPoint must be greater
  /// than the time of the previous JiljuPoint.
  void addJiljuPoint(JiljuPoint jiljuPoint) {
    if (points.last.time >= jiljuPoint.time) {
      throw Exception();
    }
    endTime = jiljuPoint.time;
    distance += points.last.calculateDistance(jiljuPoint);
    points.add(jiljuPoint);
  }

  DateTime startTimeToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
  }
}
