import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

import 'file.dart';
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
  static Future<List<Jilju>> getJiljuList(
      DateTime fromDateTime, DateTime toDateTime) async {
    var box = await _jiljuBox;
    return box.values.where((jilju) {
      DateTime jiljuDateTime = jilju.startTimeToDateTime();
      return fromDateTime.compareTo(jiljuDateTime) <= 0 &&
          jiljuDateTime.compareTo(toDateTime) < 0;
    }).toList();
  }

  static Future<int> getNextJiljuId() async {
    var box = await _jiljuBox;
    return box.keys.isEmpty ? 1 : (box.keys.last + 1);
  }

  static Future<void> loadSampleDatas() async {
    List<String> sampleDatas = [];
    for (int i = 1; i < 3; i++) {
      sampleDatas.add(await FileManager.readFileAsString('sample_data_$i.txt'));
    }
    for (int i = 0; i < 4; i++) {
      int startTime = DateTime.now()
          .subtract(Duration(days: max(2 - i, 0), hours: 3 - i))
          .millisecondsSinceEpoch;
      startTime ~/= 1000;
      String fileData =
          startTime.toString() + '\n' + sampleDatas[i % sampleDatas.length];
      DatabaseManager.putJilju(i + 1, Jilju.fromFileData(fileData));
    }
  }
}
