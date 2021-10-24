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
  List<int> jiljuIds;

  JiljuTag(this.name, {this.jiljuIds = const []}) {
    jiljuIds = jiljuIds.toList();
  }

  void addJilju(Jilju jilju) {
    if (jiljuIds.contains(jilju.id)) {
      return;
    }
    jiljuIds.add(jilju.id);
    save();
  }

  void removeJilju(Jilju jilju) {
    jiljuIds.remove(jilju.id);
    save();
  }

  factory JiljuTag.fromJson(Map<String, dynamic> json) =>
      _$JiljuTagFromJson(json);

  Map<String, dynamic> toJson() => _$JiljuTagToJson(this);
}
