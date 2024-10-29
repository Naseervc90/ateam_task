// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteSearchAdapter extends TypeAdapter<RouteSearch> {
  @override
  final int typeId = 1;

  @override
  RouteSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteSearch(
      startLocation: fields[0] as Location,
      endLocation: fields[1] as Location,
      searchTime: fields[2] as DateTime,
      distance: fields[3] as double,
      duration: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RouteSearch obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.startLocation)
      ..writeByte(1)
      ..write(obj.endLocation)
      ..writeByte(2)
      ..write(obj.searchTime)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
