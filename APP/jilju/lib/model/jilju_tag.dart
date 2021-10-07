import 'package:hive_flutter/hive_flutter.dart';

import '../database.dart';
import 'jilju.dart';

part 'jilju_tag.g.dart';

@HiveType(typeId: 2)
class JiljuTag extends HiveObject {
  static final JiljuTag emptyTag = JiljuTag('__EMPTY__');

  @HiveField(0)
  String name;

  @HiveField(1)
  List<Jilju> jiljus;

  JiljuTag(this.name) : jiljus = [];

  bool addJilju(Jilju jilju) {
    if (jiljus.contains(jilju)) {
      return false;
    }
    jiljus.add(jilju);
    save();
    return true;
  }

  bool removeJilju(Jilju jilju) {
    if (!jiljus.contains(jilju)) {
      return false;
    }
    jiljus.remove(jilju);
    save();
    if (jiljus.isEmpty) {
      DatabaseManager.deleteJiljuTag(this);
    }
    return true;
  }
}
