import 'package:equatable/equatable.dart';
import 'package:farm_express/features/consumer/consumer_profile/domain/entities/profile_entity.dart';

enum ConsumerProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class ConsumerProfileState extends Equatable {
  final ConsumerProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  const ConsumerProfileState({
    this.status = ConsumerProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ConsumerProfileState copyWith({
    ConsumerProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
  }) {
    return ConsumerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
