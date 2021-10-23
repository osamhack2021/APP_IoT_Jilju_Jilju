import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'jilju.dart';

part 'jilju_tag.g.dart';

@JsonSerializable()
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

  factory JiljuTag.fromJson(Map<String, dynamic> json) =>
      _$JiljuTagFromJson(json);

  Map<String, dynamic> toJson() => _$JiljuTagToJson(this);
}
