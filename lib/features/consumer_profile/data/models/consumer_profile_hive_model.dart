import 'package:farm_express/core/constants/hive_table_constant.dart';
import 'package:farm_express/features/consumer_profile/domain/entities/profile_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'consumer_profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.consumerProfileTypeId)
class ConsumerProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? userId;

  @HiveField(2)
  final String? fullName;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String? location;

  @HiveField(6)
  final String? profileImage;

  ConsumerProfileHiveModel({
    String? id,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.location,
    this.profileImage,
  }) : id = id ?? Uuid().v4();

  // From entity
  factory ConsumerProfileHiveModel.fromEntity(ProfileEntity entity) {
    return ConsumerProfileHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      location: entity.location,
      profileImage: entity.profileImage,
    );
  }

  // To entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
      profileImage: profileImage,
    );
  }
}
