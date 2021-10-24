// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jilju_tag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JiljuTagAdapter extends TypeAdapter<JiljuTag> {
  @override
  final int typeId = 2;

  @override
  JiljuTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JiljuTag(
      fields[0] as String,
      jiljuIds: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, JiljuTag obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.jiljuIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiljuTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiljuTag _$JiljuTagFromJson(Map<String, dynamic> json) => JiljuTag(
      json['name'] as String,
      jiljuIds:
          (json['jiljuIds'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
    );

Map<String, dynamic> _$JiljuTagToJson(JiljuTag instance) => <String, dynamic>{
      'name': instance.name,
      'jiljuIds': instance.jiljuIds,
    };
