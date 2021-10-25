import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jilju_point.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class JiljuPoint extends HiveObject {
  @HiveField(0)
  int time;

  @HiveField(1)
  int x;

  @HiveField(2)
  int y;

  JiljuPoint(this.time, this.x, this.y);

  /// Convert the x-coordinate to latitude and return it. Since the
  /// calculation is based on 37 degrees north latitude, errors may occur
  /// depending on the starting position of the Jilju.
  double get _latitude => 37 + (y / 100000);

  /// Convert the y-coordinate to longitude and return it. Since the
  /// calculation is based on the 127 degree east longitude, errors may occur
  /// depending on the starting position of the Jilju.
  double get _longitude => 127 + (x / 100000);

  /// Calculates the distance from other JiljuPoint and returns it in km.
  double calculateDistance(JiljuPoint other) {
    return Geolocator.distanceBetween(
            _latitude, _longitude, other._latitude, other._longitude) /
        1000;
  }

  factory JiljuPoint.fromJson(Map<String, dynamic> json) =>
      _$JiljuPointFromJson(json);

  Map<String, dynamic> toJson() => _$JiljuPointToJson(this);
}
