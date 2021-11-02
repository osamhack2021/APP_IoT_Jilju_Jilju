import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

import 'model/jilju.dart';
import 'model/jilju_tag.dart';
import 'util.dart';

class DatabaseManager {
  static final Future<Box<Jilju>> _jiljuBox = Hive.openBox<Jilju>('jilju');
  static final Future<Box<JiljuTag>> _jiljuTagBox =
      Hive.openBox<JiljuTag>('jiljuTag');

  static Future<void> putJilju(Jilju jilju) async {
    var box = await _jiljuBox;
    return box.put(jilju.id, jilju);
  }

  static Future<void> deleteJilju(Jilju jilju) async {
    var box = await _jiljuBox;
    return box.delete(jilju.id);
  }

  static Future<void> putJiljuTag(JiljuTag jiljuTag) async {
    var box = await _jiljuTagBox;
    return box.put(jiljuTag.name, jiljuTag);
  }

  static Future<void> deleteJiljuTag(JiljuTag jiljuTag) async {
    var box = await _jiljuTagBox;
    return box.delete(jiljuTag.name);
  }

  static Future<bool> containsJiljuTag(String tagName) async {
    var box = await _jiljuTagBox;
    return box.containsKey(tagName);
  }

  static Future<List<JiljuTag>> getAllJiljuTags() async {
    var box = await _jiljuTagBox;
    return box.values.toList();
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

  static Future<void> loadSampleData(int seed) async {
    List<String> sampleDatas = [];
    for (int i = 1; i < 3; i++) {
      sampleDatas.add(await readFileAsString('sample_data_$i.txt'));
    }
    Random random = Random(seed);
    int fileId = 1;
    for (int day = -29; day <= 0; day++) {
      int j = 0;
      for (int i = 1; i < 3; i++) {
        for (; random.nextBool(); j++) {
          int startTime = DateTime.now()
              .add(Duration(days: day, hours: j))
              .millisecondsSinceEpoch;
          startTime ~/= 1000;
          String fileData = startTime.toString() + '\n' + sampleDatas[i - 1];
          DatabaseManager.putJilju(Jilju.fromFileData(fileId, fileData));
          fileId++;
        }
      }
    }
  }

  static Future<void> clearAllData() async {
    var jiljuBox = await _jiljuBox;
    var jiljuTagBox = await _jiljuTagBox;
    await jiljuBox.clear();
    await jiljuTagBox.clear();
  }

  static Future<String> toJson() async {
    var jiljuBox = await _jiljuBox;
    var jiljuTagBox = await _jiljuTagBox;
    Map<String, dynamic> json = {
      'jilju': jiljuBox.toMap().map(
          (key, value) => MapEntry(key.toString(), value.simplifyPoints())),
      'jiljuTag': jiljuTagBox
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value)),
    };
    return jsonEncode(json);
  }

  static Future<void> fromJson(String jsonString) async {
    Map<String, dynamic> json = jsonDecode(jsonString);
    var jiljuBox = await _jiljuBox;
    var jiljuTagBox = await _jiljuTagBox;
    await jiljuBox.putAll(Map.from(json['jilju'])
        .map((key, value) => MapEntry(int.parse(key), Jilju.fromJson(value))));
    await jiljuTagBox.putAll(Map.from(json['jiljuTag'])
        .map((key, value) => MapEntry(key, JiljuTag.fromJson(value))));
  }
}
