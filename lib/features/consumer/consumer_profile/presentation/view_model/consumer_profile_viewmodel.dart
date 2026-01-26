
import 'package:farm_express/features/consumer/consumer_profile/domain/usecases/get_consumer_profile_usecases.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/usecases/update_consumer_profile_usecase.dart';
import 'package:farm_express/features/consumer/consumer_profile/presentation/state/consumer_profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumerProfileViewmodelProvider =
    NotifierProvider<ConsumerProfileViewmodel, ConsumerProfileState>(
      () => ConsumerProfileViewmodel(),
    );

class ConsumerProfileViewmodel extends Notifier<ConsumerProfileState> {
  late final GetConsumerProfileUsecases _getConsumerProfileUsecases;
  late final UpdateConsumerProfileUsecase _updateConsumerProfileUsecase;

  @override
  ConsumerProfileState build() {
    _getConsumerProfileUsecases = ref.read(getConsumerProfileUsecasesProvider);
    _updateConsumerProfileUsecase = ref.read(
      updateConsumerProfileUsecaseProvider,
    );
    return ConsumerProfileState();
  }

  Future<void> getConsumerUser() async {
    state = state.copyWith(status: ConsumerProfileStatus.loading);
    final result = await _getConsumerProfileUsecases.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ConsumerProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profileData) {
        state = state.copyWith(
          status: ConsumerProfileStatus.loaded,
          profile: profileData,
        );
      },
    );
  }

  Future<void> updateProfile(UpdateConsumerProfileUsecaseParams data) async {
    state = state.copyWith(status: ConsumerProfileStatus.loading);

    final result = await _updateConsumerProfileUsecase.call(data);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ConsumerProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) async {
        state = state.copyWith(
          status: ConsumerProfileStatus.updated,
          profile: success,
        );

        await getConsumerUser();
      },
    );
  }
}
