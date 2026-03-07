import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/services/connectivity/network_info.dart';
import 'package:farm_express/core/services/hive/hive_service.dart';
import 'package:farm_express/features/consumer_profile/data/datasources/consumer_profile_datasource.dart';
import 'package:farm_express/features/consumer_profile/data/datasources/remote/consumer_profile_remotedatasource.dart';
import 'package:farm_express/features/consumer_profile/data/models/consumer_profile_hive_model.dart';
import 'package:farm_express/features/consumer_profile/data/models/profile_api_model.dart';
import 'package:farm_express/features/consumer_profile/domain/entities/profile_entity.dart';
import 'package:farm_express/features/consumer_profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumerProfileRepositoryProvider = Provider<ConsumerProfileRepository>((
  ref,
) {
  return ConsumerProfileRepository(
    iConsumerProfileRemoteDatasource: ref.read(
      consumerProfileRemoteDatasourceProvider,
    ),
    hiveService: ref.read(hiveServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class ConsumerProfileRepository implements IProfileRepository {
  final IConsumerProfileRemoteDatasource _consumerProfileRemoteDatasource;
  final HiveService _hiveService;
  final INetworkInfo _networkInfo;

  ConsumerProfileRepository({
    required IConsumerProfileRemoteDatasource iConsumerProfileRemoteDatasource,
    required HiveService hiveService,
    required INetworkInfo networkInfo,
  }) : _consumerProfileRemoteDatasource = iConsumerProfileRemoteDatasource,
       _hiveService = hiveService,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> getUserDetails() async {
    try {
      final response = await _consumerProfileRemoteDatasource
          .getConsumerProfile();

      // Save to Hive for offline access
      final hiveModel = ConsumerProfileHiveModel.fromEntity(
        response.toEntity(),
      );
      await _hiveService.saveConsumerProfile(hiveModel);

      return right(response.toEntity());
    } catch (e) {
      // If offline, try to return cached profile
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        try {
          final cachedProfile = await _hiveService.getConsumerProfile();
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
  Future<Either<Failure, ProfileEntity>> updateUser(
    ProfileEntity updatedUser,
    File? image,
  ) async {
    try {
      final newData = ProfileApiModel.fromEntity(updatedUser);
      final response = await _consumerProfileRemoteDatasource.updateProfile(
        newData,
        image,
      );

      // Save to Hive for offline access
      final hiveModel = ConsumerProfileHiveModel.fromEntity(
        response.toEntity(),
      );
      await _hiveService.saveConsumerProfile(hiveModel);

      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
