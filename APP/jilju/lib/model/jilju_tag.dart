import 'package:hive_flutter/hive_flutter.dart';

import 'jilju.dart';

part 'jilju_tag.g.dart';

@HiveType(typeId: 2)
class JiljuTag extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Jilju> jiljus;

  JiljuTag(this.name, {this.jiljus = const []}) {
    jiljus = jiljus.toList();
  }

  void addJilju(Jilju jilju) {
    if (jiljus.contains(jilju)) {
      return;
    }
    jiljus.add(jilju);
    save();
  }

  void removeJilju(Jilju jilju) {
    jiljus.remove(jilju);
    save();
  }
}
