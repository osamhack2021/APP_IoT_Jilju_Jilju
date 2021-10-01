import 'package:hive_flutter/hive_flutter.dart';

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
    List<Jilju> jiljuList = [];
    var box = await _jiljuBox;
    for (Jilju jilju in box.values) {
      DateTime jiljuDateTime = jilju.startTimeToDateTime();
      if (fromDateTime.compareTo(jiljuDateTime) <= 0 &&
          jiljuDateTime.compareTo(toDateTime) > 0) {
        jiljuList.add(jilju);
      }
    }
    return jiljuList;
  }

  static Future<int> getNextJiljuId() async {
    var box = await _jiljuBox;
    return box.keys.isEmpty ? 1 : (box.keys.last + 1);
  }
}
