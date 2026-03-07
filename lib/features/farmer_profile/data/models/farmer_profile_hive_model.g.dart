// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_profile_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmerProfileHiveModelAdapter
    extends TypeAdapter<FarmerProfileHiveModel> {
  @override
  final int typeId = 2;

  @override
  FarmerProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmerProfileHiveModel(
      id: fields[0] as String?,
      fullName: fields[1] as String?,
      email: fields[2] as String?,
      farmName: fields[3] as String?,
      description: fields[4] as String?,
      farmLocation: fields[5] as String?,
      phoneNumber: fields[6] as String?,
      profileImage: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FarmerProfileHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.farmName)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.farmLocation)
      ..writeByte(6)
      ..write(obj.phoneNumber)
      ..writeByte(7)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmerProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
