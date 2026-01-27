import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/repositories/consumer_profile_repository.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/entities/profile_entity.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateConsumerProfileUsecaseParams {
  final String? fullName;
  final String? email;
  final String? location;
  final String? phoneNumber;
  final String? profileImageUrl;
  final File? profileImage;

  UpdateConsumerProfileUsecaseParams({
    this.fullName,
    this.email,
    this.location,
    this.phoneNumber,
    this.profileImageUrl,
    this.profileImage,
  });
}

final updateConsumerProfileUsecaseProvider =
    Provider<UpdateConsumerProfileUsecase>((ref) {
      return UpdateConsumerProfileUsecase(
        iProfileRepository: ref.read(consumerProfileRepositoryProvider),
      );
    });

class UpdateConsumerProfileUsecase
    implements
        UsecaseWithParams<ProfileEntity, UpdateConsumerProfileUsecaseParams> {
  final IProfileRepository _iProfileRepository;

  UpdateConsumerProfileUsecase({required IProfileRepository iProfileRepository})
    : _iProfileRepository = iProfileRepository;
  @override
  Future<Either<Failure, ProfileEntity>> call(params) {
    final entity = ProfileEntity(
      fullName: params.fullName,
      email: params.email,
      location: params.location,
      phoneNumber: params.phoneNumber,
      profileImage: params.profileImageUrl,
    );
    return _iProfileRepository.updateUser(entity, params.profileImage);
  }
}
