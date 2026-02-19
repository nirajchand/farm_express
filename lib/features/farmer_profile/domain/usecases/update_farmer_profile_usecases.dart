import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';

import 'package:farm_express/features/farmer_profile/data/repositories/farmer_profile_repository.dart';
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';
import 'package:farm_express/features/farmer_profile/domain/repositories/farmer_profile_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateFarmerProfileUsecaseParams {
  final String? fullName;
  final String? email;
  final String? farmName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final File? profileImage;
  final String? farmLocation;
  final String? description;

  UpdateFarmerProfileUsecaseParams({
    this.fullName,
    this.email,
    this.farmName,
    this.phoneNumber,
    this.profileImageUrl,
    this.profileImage,
    this.farmLocation,
    this.description,
  });
}

final updateFarmerProfileUsecaseProvider =
    Provider<UpdateFarmerProfileUsecase>((ref) {
      return UpdateFarmerProfileUsecase(
        iFarmerProfileRepository: ref.read(farmerProfileRepositoryProvider),
      );
    });

class UpdateFarmerProfileUsecase
    implements
        UsecaseWithParams<FarmerProfileEntity, UpdateFarmerProfileUsecaseParams> {
  final IFarmerProfileRepository _iFarmerProfileRepository;

  UpdateFarmerProfileUsecase({required IFarmerProfileRepository iFarmerProfileRepository})
    : _iFarmerProfileRepository = iFarmerProfileRepository;
  @override
  Future<Either<Failure, FarmerProfileEntity>> call(params) {
    final entity = FarmerProfileEntity(
      fullName: params.fullName,
      email: params.email,
      farmLocation: params.farmLocation,
      phoneNumber: params.phoneNumber,
      profileImage: params.profileImageUrl,
      description: params.description, 
      farmName: params.farmName,
    );
    return _iFarmerProfileRepository.updateFarmerProfile(entity, params.profileImage);
  }
}
