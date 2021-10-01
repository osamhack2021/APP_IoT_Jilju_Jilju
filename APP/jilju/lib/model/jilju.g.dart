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
    )
      ..endTime = fields[1] as int
      ..distance = fields[2] as double
      ..points = (fields[3] as List).cast<JiljuPoint>();
  }

  @override
  void write(BinaryWriter writer, Jilju obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
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
