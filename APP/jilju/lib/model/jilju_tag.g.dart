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
      jiljus: (fields[1] as List).cast<Jilju>(),
    );
  }

  @override
  void write(BinaryWriter writer, JiljuTag obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.jiljus);
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
