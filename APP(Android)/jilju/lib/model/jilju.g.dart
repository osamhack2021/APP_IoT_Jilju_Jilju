// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jilju.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JiljuAdapter extends TypeAdapter<Jilju> {
  @override
  final int typeId = 0;

  @override
  Jilju read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jilju(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
      fields[3] as double,
      (fields[4] as List).cast<JiljuPoint>(),
    );
  }

  @override
  void write(BinaryWriter writer, Jilju obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JiljuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jilju _$JiljuFromJson(Map<String, dynamic> json) => Jilju(
      json['id'] as int,
      json['startTime'] as int,
      json['endTime'] as int,
      (json['distance'] as num).toDouble(),
      (json['points'] as List<dynamic>)
          .map((e) => JiljuPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JiljuToJson(Jilju instance) => <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'distance': instance.distance,
      'points': instance.points,
    };
