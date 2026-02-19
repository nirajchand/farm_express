import 'package:equatable/equatable.dart';
import 'package:farm_express/features/farmer_profile/domain/entities/farmer_profile_entity.dart';

enum FarmerProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class FarmerProfileState extends Equatable {
  final FarmerProfileStatus status;
  final FarmerProfileEntity? profile;
  final String? errorMessage;

  const FarmerProfileState({
    this.status = FarmerProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  FarmerProfileState copyWith({
    FarmerProfileStatus? status,
    FarmerProfileEntity? profile,
    String? errorMessage,
  }) {
    return FarmerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
