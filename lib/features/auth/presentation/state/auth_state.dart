import 'package:equatable/equatable.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
}

enum UserRole {
  farmer,
  consumer
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final AuthEntity? user;
  final UserRole? userType;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
    this.userType
  });

  // copywith
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthEntity? user,
    UserRole? userType
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      userType: userType ?? this.userType
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user,userType];
}
