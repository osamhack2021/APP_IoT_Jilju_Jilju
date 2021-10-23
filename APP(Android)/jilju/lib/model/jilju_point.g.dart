// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jilju_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JiljuPointAdapter extends TypeAdapter<JiljuPoint> {
  @override
  final int typeId = 1;

  @override
  JiljuPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JiljuPoint(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, JiljuPoint obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiljuPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiljuPoint _$JiljuPointFromJson(Map<String, dynamic> json) => JiljuPoint(
      json['time'] as int,
      json['x'] as int,
      json['y'] as int,
    );

Map<String, dynamic> _$JiljuPointToJson(JiljuPoint instance) =>
    <String, dynamic>{
      'time': instance.time,
      'x': instance.x,
      'y': instance.y,
    };
