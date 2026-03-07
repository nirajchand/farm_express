import 'package:farm_express/core/constants/hive_table_constant.dart';
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'farmer_profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.farmerProfileTypeId)
class FarmerProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? farmName;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? farmLocation;

  @HiveField(6)
  final String? phoneNumber;

  @HiveField(7)
  final String? profileImage;

  FarmerProfileHiveModel({
    String? id,
    this.fullName,
    this.email,
    this.farmName,
    this.description,
    this.farmLocation,
    this.phoneNumber,
    this.profileImage,
  }) : id = id ?? Uuid().v4();

  // From entity
  factory FarmerProfileHiveModel.fromEntity(FarmerProfileEntity entity) {
    return FarmerProfileHiveModel(
      fullName: entity.fullName,
      email: entity.email,
      farmName: entity.farmName,
      description: entity.description,
      farmLocation: entity.farmLocation,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
    );
  }

  // To entity
  FarmerProfileEntity toEntity() {
    return FarmerProfileEntity(
      fullName: fullName,
      email: email,
      farmName: farmName,
      description: description,
      farmLocation: farmLocation,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
    );
  }
}
