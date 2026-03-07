// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_profile_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsumerProfileHiveModelAdapter
    extends TypeAdapter<ConsumerProfileHiveModel> {
  @override
  final int typeId = 3;

  @override
  ConsumerProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumerProfileHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      fullName: fields[2] as String?,
      email: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      location: fields[5] as String?,
      profileImage: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConsumerProfileHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumerProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
