
import 'package:farm_express/features/farmer/farmer_profile/domain/usecases/get_farmer_profile_usecases.dart';
import 'package:farm_express/features/farmer/farmer_profile/domain/usecases/update_farmer_profile_usecases.dart';
import 'package:farm_express/features/farmer/farmer_profile/presentation/state/farmer_profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final farmerProfileViewmodelProvider =
    NotifierProvider<FarmerProfileViewmodel, FarmerProfileState>(
      () => FarmerProfileViewmodel(),
    );

class FarmerProfileViewmodel extends Notifier<FarmerProfileState> {
  late final GetFarmerProfileUsecases _getFarmerProfileUsecases;
  late final UpdateFarmerProfileUsecase _updateFarmerProfileUsecase;

  @override
  FarmerProfileState build() {
    _getFarmerProfileUsecases = ref.read(getFarmerProfileUsecasesProvider);
    _updateFarmerProfileUsecase = ref.read(
      updateFarmerProfileUsecaseProvider,
    );
    return FarmerProfileState();
  }

  Future<void> getFarmerUser() async {
    state = state.copyWith(status: FarmerProfileStatus.loading);
    final result = await _getFarmerProfileUsecases.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: FarmerProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profileData) {
        state = state.copyWith(
          status: FarmerProfileStatus.loaded,
          profile: profileData,
        );
      },
    );
  }

  Future<void> updateProfile(UpdateFarmerProfileUsecaseParams data) async {
    state = state.copyWith(status: FarmerProfileStatus.loading);

    final result = await _updateFarmerProfileUsecase.call(data);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FarmerProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) async {
        state = state.copyWith(
          status: FarmerProfileStatus.updated,
          profile: success,
        );

        await getFarmerUser();
      },
    );
  }
}
