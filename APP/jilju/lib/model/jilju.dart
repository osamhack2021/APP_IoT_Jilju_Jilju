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

  Jilju(this.startTime, this.endTime, this.distance, this.points);

  Jilju.fromFileData(String fileData)
      : startTime = 0,
        endTime = 0,
        distance = 0,
        points = [JiljuPoint(0, 0, 0)] {
    List<String> tokens = fileData.split('\n');
    startTime = endTime = int.parse(tokens[0]);
    for (int i = 1; i < tokens.length - 1; i++) {
      List<int> jiljuPointDatas = tokens[i].split(',').map(int.parse).toList();
      _addJiljuPoint(JiljuPoint(
          jiljuPointDatas[0], jiljuPointDatas[1], jiljuPointDatas[2]));
    }
  }

  int totalTime() {
    return endTime - startTime;
  }

  /// Add a new JiljuPoint. The time of the new JiljuPoint must be greater
  /// than the time of the previous JiljuPoint.
  void _addJiljuPoint(JiljuPoint jiljuPoint) {
    if (points.last.time >= jiljuPoint.time) {
      throw Exception();
    }
    endTime = startTime + jiljuPoint.time;
    distance += points.last.calculateDistance(jiljuPoint);
    points.add(jiljuPoint);
  }

  DateTime startTimeToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
  }

  @override
  String toString() {
    return '$startTime,$endTime,$distance,$points';
  }

  static int getSumOfTotalTime(List<Jilju> jiljuList) {
    return jiljuList.map((jilju) => jilju.totalTime()).reduce((a, b) => a + b);
  }

  static double getSumOfDistance(List<Jilju> jiljuList) {
    return jiljuList.map((jilju) => jilju.distance).reduce((a, b) => a + b);
  }
}
