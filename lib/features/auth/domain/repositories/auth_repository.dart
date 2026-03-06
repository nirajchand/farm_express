import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(AuthEntity user);
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> sendToken(String email);
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword);

}
