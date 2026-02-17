// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerProfileApiModel _$FarmerProfileApiModelFromJson(
        Map<String, dynamic> json) =>
    FarmerProfileApiModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      farmName: json['farmName'] as String?,
      description: json['description'] as String?,
      farmLocation: json['farmLocation'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$FarmerProfileApiModelToJson(
        FarmerProfileApiModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'farmName': instance.farmName,
      'description': instance.description,
      'farmLocation': instance.farmLocation,
      'phoneNumber': instance.phoneNumber,
      'profile_image': instance.profileImage,
    };
