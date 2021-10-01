import 'package:geolocator/geolocator.dart';

class Jilju {
  final int id;
  final int startTime;
  final int endTime;
  final double distance;

  Jilju(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.distance});

  Map<String, dynamic> toMap() {
    return {
      'jilju_id': id,
      'start_time': startTime,
      'end_time': endTime,
      'distance': distance,
    };
  }
}

class JiljuPoint {
  final int id;
  final int jiljuId;
  final int time;
  final int x;
  final int y;

  JiljuPoint(
      {required this.id,
      required this.jiljuId,
      required this.time,
      required this.x,
      required this.y});

  Map<String, dynamic> toMap() {
    return {
      'jilju_point_id': id,
      'jilju_id': jiljuId,
      'time': time,
      'x': x,
      'y': y,
    };
  }

  /// x 좌표를 위도로 변환하여 반환합니다. 북위 37도를 기준으로 계산하므로
  /// 뜀걸음 시작 위치에 따라 오차가 발생할 수 있습니다.
  double _latitude() {
    return 37 + (x / 100000);
  }

  /// y 좌표를 경도로 변환하여 반환합니다. 동경 127도를 기준으로 계산하므로
  /// 뜀걸음 시작 위치에 따라 오차가 발생할 수 있습니다.
  double _longitude() {
    return 127 + (y / 100000);
  }

  /// 인자로 받은 JiljuPoint와의 거리를 계산하여 km 단위로 반환합니다.
  double calculateDistance(JiljuPoint other) {
    return Geolocator.distanceBetween(
        _latitude(), _longitude(), other._latitude(), other._longitude());
  }
}
