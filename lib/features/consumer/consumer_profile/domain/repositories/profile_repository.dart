import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getUserDetails();
  Future<Either<Failure, ProfileEntity>> updateUser(ProfileEntity updatedUser,File? image);
}
