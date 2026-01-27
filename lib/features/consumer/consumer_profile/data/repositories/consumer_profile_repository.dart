import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/datasources/consumer_profile_datasource.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/datasources/remote/consumer_profile_remotedatasource.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/models/profile_api_model.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/entities/profile_entity.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumerProfileRepositoryProvider = Provider<ConsumerProfileRepository>((
  ref,
) {
  return ConsumerProfileRepository(
    iConsumerProfileRemoteDatasource: ref.read(
      consumerProfileRemoteDatasourceProvider,
    ),
  );
});

class ConsumerProfileRepository implements IProfileRepository {
  final IConsumerProfileRemoteDatasource _consumerProfileRemoteDatasource;

  ConsumerProfileRepository({
    required IConsumerProfileRemoteDatasource iConsumerProfileRemoteDatasource,
  }) : _consumerProfileRemoteDatasource = iConsumerProfileRemoteDatasource;
  @override
  Future<Either<Failure, ProfileEntity>> getUserDetails() async {
    try {
      final response = await _consumerProfileRemoteDatasource
          .getConsumerProfile();
      return right(response.toEntity());
    } catch (e) {
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
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
