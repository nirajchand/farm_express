import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
import 'package:farm_express/core/services/hive/hive_service.dart';
import 'package:farm_express/core/services/image_cache/image_cache_service.dart';
import 'package:farm_express/features/farmer_profile/data/datasources/farmer_profile_datasource.dart';
import 'package:farm_express/features/farmer_profile/data/datasources/remote/farmer_profile_remote_datasource.dart';
import 'package:farm_express/features/farmer_profile/data/models/farmer_profile_api_model.dart';
import 'package:farm_express/features/farmer_profile/data/models/farmer_profile_hive_model.dart';
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
    hiveService: ref.read(hiveServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
    imageCacheService: ref.read(imageCacheServiceProvider),
  );
});

class FarmerProfileRepository implements IFarmerProfileRepository {
  final IFarmerProfileRemoteDatasource _farmerProfileRemoteDatasource;
  final HiveService _hiveService;
  final INetworkInfo _networkInfo;
  final ImageCacheService _imageCacheService;

  FarmerProfileRepository({
    required IFarmerProfileRemoteDatasource iFarmerProfileRemoteDatasource,
    required HiveService hiveService,
    required INetworkInfo networkInfo,
    required ImageCacheService imageCacheService,
  }) : _farmerProfileRemoteDatasource = iFarmerProfileRemoteDatasource,
       _hiveService = hiveService,
       _networkInfo = networkInfo,
       _imageCacheService = imageCacheService;

  @override
  Future<Either<Failure, FarmerProfileEntity>> getFarmerProfile() async {
    try {
      final response = await _farmerProfileRemoteDatasource.getFarmerProfile();

      // Cache profile image if available
      if (response.profileImage != null && response.profileImage!.isNotEmpty) {
        _imageCacheService.cacheImage(response.profileImage!).ignore();
      }

      // Save to Hive for offline access
      final hiveModel = FarmerProfileHiveModel.fromEntity(response.toEntity());
      await _hiveService.saveFarmerProfile(hiveModel);

      return right(response.toEntity());
    } catch (e) {
      // If offline, try to return cached profile
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        try {
          final cachedProfile = await _hiveService.getFarmerProfile();
          if (cachedProfile != null) {
            return Right(cachedProfile.toEntity());
          }
        } catch (cacheError) {
          return Left(CacheFailure(message: "No cached profile available"));
        }
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProfileEntity>> updateFarmerProfile(
    FarmerProfileEntity updatedUser,
    File? image,
  ) async {
    // Check internet connection first
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(
        ServerFailure(
          message:
              "No internet connection. Please check your WiFi or mobile data.",
        ),
      );
    }

    try {
      final newData = FarmerProfileApiModel.fromEntity(updatedUser);
      final response = await _farmerProfileRemoteDatasource.updateProfile(
        newData,
        image,
      );

      // Cache profile image if available
      if (response.profileImage != null && response.profileImage!.isNotEmpty) {
        _imageCacheService.cacheImage(response.profileImage!).ignore();
      }

      // Save to Hive for offline access
      final hiveModel = FarmerProfileHiveModel.fromEntity(response.toEntity());
      await _hiveService.saveFarmerProfile(hiveModel);

      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
