import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/farmer_profile/data/datasources/farmer_profile_datasource.dart';
import 'package:farm_express/features/farmer_profile/data/datasources/remote/farmer_profile_remote_datasource.dart';
import 'package:farm_express/features/farmer_profile/data/models/farmer_profile_api_model.dart';
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';
import 'package:farm_express/features/farmer_profile/domain/repositories/farmer_profile_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final farmerProfileRepositoryProvider = Provider<FarmerProfileRepository>((
  ref,
) {
  return FarmerProfileRepository(
    iFarmerProfileRemoteDatasource: ref.read(
      farmerProfileRemoteDatasourceProvider,
    ),
  );
});

class FarmerProfileRepository implements IFarmerProfileRepository {
  final IFarmerProfileRemoteDatasource _farmerProfileRemoteDatasource;

  FarmerProfileRepository({
    required IFarmerProfileRemoteDatasource iFarmerProfileRemoteDatasource,
  }) : _farmerProfileRemoteDatasource = iFarmerProfileRemoteDatasource;
  @override
  Future<Either<Failure, FarmerProfileEntity>> getFarmerProfile() async {
    try {
      final response = await _farmerProfileRemoteDatasource
          .getFarmerProfile();
      return right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProfileEntity>> updateFarmerProfile(
    FarmerProfileEntity updatedUser,
    File? image,
  ) async {
    try {
      final newData = FarmerProfileApiModel.fromEntity(updatedUser);
      final response = await _farmerProfileRemoteDatasource.updateProfile(
        newData,
        image,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
