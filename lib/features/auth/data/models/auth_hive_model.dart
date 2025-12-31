import 'package:farm_express/core/constants/hive_table_constant.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? password;

  @HiveField(3)
  final String? confirmPassword;

  AuthHiveModel({
    String? userId,
    required this.email,
    this.password,
    this.confirmPassword,
  }): userId = userId ?? Uuid().v4();

  // From entity 
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  // To entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
