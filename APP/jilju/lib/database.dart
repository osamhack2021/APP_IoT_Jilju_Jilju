import 'dart:collection';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

import 'util.dart';
import 'model/jilju.dart';

class DatabaseManager {
  static final Future<Box<Jilju>> _jiljuBox = Hive.openBox<Jilju>('jilju');

  static void putJilju(int id, Jilju jilju) async {
    var box = await _jiljuBox;
    box.put(id, jilju);
  }

  static Future<Jilju?> getJilju(int id) async {
    var box = await _jiljuBox;
    return box.get(id);
  }

  /// Returns all Jiljus whose startTime is greater than or equal to
  /// fromDateTime and is less then toDateTime.
  static Future<List<Jilju>> _getJiljuList(
      DateTime fromDateTime, DateTime toDateTime) async {
    var box = await _jiljuBox;
    return box.values.where((jilju) {
      DateTime jiljuDateTime = secondsToDateTime(jilju.startTime);
      return fromDateTime.compareTo(jiljuDateTime) <= 0 &&
          jiljuDateTime.compareTo(toDateTime) < 0;
    }).toList();
  }

  static Future<Map<DateTime, List<Jilju>>> getJiljuMap(
      DateTime startDate, int count) async {
    Map<DateTime, List<Jilju>> jiljuMap = SplayTreeMap();
    for (int idx = 0; idx < count; idx++) {
      DateTime dateTime = startDate.add(Duration(days: idx));
      jiljuMap[dateTime] =
          await _getJiljuList(dateTime, dateTime.add(const Duration(days: 1)));
    }
    return jiljuMap;
  }

  static Future<int> getNextJiljuId() async {
    var box = await _jiljuBox;
    return box.keys.isEmpty ? 1 : (box.keys.last + 1);
  }

  static Future<void> loadSampleDatas(int seed) async {
    List<String> sampleDatas = [];
    for (int i = 1; i < 3; i++) {
      sampleDatas.add(await readFileAsString('sample_data_$i.txt'));
    }
    Random random = Random(seed);
    int fileId = 1;
    for (int day = -29; day <= 0; day++) {
      for (int i = 1; i < 3; i++) {
        for (int j = 0; random.nextBool(); j++) {
          int startTime = DateTime.now()
              .add(Duration(days: day, hours: j))
              .millisecondsSinceEpoch;
          startTime ~/= 1000;
          String fileData = startTime.toString() + '\n' + sampleDatas[i - 1];
          DatabaseManager.putJilju(fileId++, Jilju.fromFileData(fileData));
        }
      }
    }
  }
}
