import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/consumer_profile/data/repositories/consumer_profile_repository.dart';
import 'package:farm_express/features/consumer_profile/domain/entities/profile_entity.dart';
import 'package:farm_express/features/consumer_profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getConsumerProfileUsecasesProvider = Provider<GetConsumerProfileUsecases>(
  (ref) {
    return GetConsumerProfileUsecases(
      iProfileRepository: ref.read(consumerProfileRepositoryProvider),
    );
  },
);

class GetConsumerProfileUsecases implements UseecaseWithoutParams {
  final IProfileRepository _iProfileRepository;

  const GetConsumerProfileUsecases({
    required IProfileRepository iProfileRepository,
  }) : _iProfileRepository = iProfileRepository;
  @override
  Future<Either<Failure, ProfileEntity>> call() async {
    return await _iProfileRepository.getUserDetails();
  }
}
