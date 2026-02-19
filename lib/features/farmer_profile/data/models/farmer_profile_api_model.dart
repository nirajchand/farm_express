
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_profile_api_model.g.dart';


@JsonSerializable()
class FarmerProfileApiModel {
  final String? fullName;
  final String? email;
  final String? farmName;
  final String? description;
  final String? farmLocation;
  final String? phoneNumber;
  @JsonKey(name: "profile_image")
  final String? profileImage;

  const FarmerProfileApiModel({
    this.fullName,
    this.email,
    this.farmName,
    this.description,
    this.farmLocation,
    this.phoneNumber,
    this.profileImage,
  });

  factory FarmerProfileApiModel.fromJson(Map<String, dynamic> json) => _$FarmerProfileApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$FarmerProfileApiModelToJson(this);
  
  FarmerProfileEntity toEntity() {
    return FarmerProfileEntity(
      fullName: fullName,
      email: email,
      farmName: farmName,
      description: description,
      farmLocation: farmLocation,
      phoneNumber: phoneNumber,
      profileImage: profileImage
    );
  }

  factory FarmerProfileApiModel.fromEntity(FarmerProfileEntity entity) {
    return FarmerProfileApiModel(
      fullName: entity.fullName,
      email: entity.email,
      farmName: entity.farmName,
      description: entity.description,
      farmLocation: entity.farmLocation,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage
    );
  }
  

}
