import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/farmer_profile/data/repositories/farmer_profile_repository.dart';
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';
import 'package:farm_express/features/farmer_profile/domain/repositories/farmer_profile_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFarmerProfileUsecasesProvider = Provider<GetFarmerProfileUsecases>(
  (ref) {
    return GetFarmerProfileUsecases(
      iFarmerProfileRepository: ref.read(farmerProfileRepositoryProvider),
    );
  },
);

class GetFarmerProfileUsecases implements UseecaseWithoutParams {
  final IFarmerProfileRepository _iFarmerProfileRepository;

  const GetFarmerProfileUsecases({
    required IFarmerProfileRepository iFarmerProfileRepository,
  }) : _iFarmerProfileRepository = iFarmerProfileRepository;
  @override
  Future<Either<Failure, FarmerProfileEntity>> call() async {
    return await _iFarmerProfileRepository.getFarmerProfile();
  }
}
