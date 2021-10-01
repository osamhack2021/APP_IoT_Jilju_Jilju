import 'package:hive_flutter/hive_flutter.dart';

import 'model/jilju.dart';

class DatabaseManager {
  static final Future<Box<Jilju>> _jiljuBox = Hive.openBox<Jilju>('jilju');

  static void putJilju(int id, Jilju jilju) async {
    var box = await _jiljuBox;
    box.put(id, jilju);
  }

  static Future<int> getNextJiljuId() async {
    var box = await _jiljuBox;
    return box.keys.isEmpty ? 1 : (box.keys.last + 1);
  }
}
