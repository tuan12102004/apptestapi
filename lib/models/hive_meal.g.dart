// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealHiveAdapter extends TypeAdapter<MealHive> {
  @override
  final int typeId = 0;

  @override
  MealHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealHive(
      idMeal: fields[0] as String,
      strMeal: fields[1] as String,
      strMealThumb: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idMeal)
      ..writeByte(1)
      ..write(obj.strMeal)
      ..writeByte(2)
      ..write(obj.strMealThumb);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
