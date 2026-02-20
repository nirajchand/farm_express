// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerModel _$FarmerModelFromJson(Map<String, dynamic> json) => FarmerModel(
      id: json['_id'] as String,
      farmName: json['farmName'] as String?,
      farmLocation: json['farmLocation'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$FarmerModelToJson(FarmerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'farmName': instance.farmName,
      'farmLocation': instance.farmLocation,
      'description': instance.description,
      'phoneNumber': instance.phoneNumber,
    };
