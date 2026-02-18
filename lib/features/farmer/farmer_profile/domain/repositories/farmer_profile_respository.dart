
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/farmer/farmer_profile/domain/entities/farmer_profile_entity.dart';

abstract class IFarmerProfileRepository {
  Future<Either<Failure, FarmerProfileEntity>> getFarmerProfile();
  Future<Either<Failure, FarmerProfileEntity>> updateFarmerProfile(FarmerProfileEntity updatedUser,File? image);
}