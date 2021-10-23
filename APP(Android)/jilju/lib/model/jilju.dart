import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../database.dart';
import 'jilju_point.dart';
import 'jilju_tag.dart';

part 'jilju.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Jilju extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int startTime;

  @HiveField(2)
  int endTime;

  @HiveField(3)
  double distance;

  @HiveField(4)
  List<JiljuPoint> points;

  Jilju(this.id, this.startTime, this.endTime, this.distance, this.points);

  Jilju.fromFileData(this.id, String fileData)
      : startTime = 0,
        endTime = 0,
        distance = 0,
        points = [JiljuPoint(0, 0, 0)] {
    List<String> tokens = fileData.split('\n');
    startTime = endTime = int.parse(tokens[0]);
    for (int i = 1; i < tokens.length - 1; i++) {
      List<int> jiljuPointDatas = tokens[i].split(',').map(int.parse).toList();
      _addJiljuPoint(JiljuPoint(
          jiljuPointDatas[0], jiljuPointDatas[2], jiljuPointDatas[1]));
    }
  }

  Duration get totalTime => Duration(seconds: endTime - startTime);

  double get averageSpeed => distance / (endTime - startTime) * 3600;

  Future<List<JiljuTag>> jiljuTags() async {
    List<JiljuTag> jiljuTags = await DatabaseManager.getAllJiljuTags();
    jiljuTags =
        jiljuTags.where((jiljuTag) => jiljuTag.jiljus.contains(this)).toList();
    return jiljuTags;
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

  factory Jilju.fromJson(Map<String, dynamic> json) => _$JiljuFromJson(json);

  Map<String, dynamic> toJson() => _$JiljuToJson(this);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    return other is Jilju && hashCode == other.hashCode;
  }

  static double getSumOfDistance(List<Jilju> jiljuList) {
    return jiljuList.map((jilju) => jilju.distance).fold(0, (a, b) => a + b);
  }

  static Duration getSumOfTotalTime(List<Jilju> jiljuList) {
    return jiljuList
        .map((jilju) => jilju.totalTime)
        .fold(Duration.zero, (a, b) => a + b);
  }
}
