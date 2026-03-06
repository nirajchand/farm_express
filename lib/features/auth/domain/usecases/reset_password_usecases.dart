import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/auth/data/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordUsecasesParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordUsecasesParams({required this.token, required this.newPassword});

  @override
  List<Object?> get props => [token, newPassword];
}

// Provider for login usecase
final resetPasswordsecasesProvider = Provider<ResetPasswordUsecases>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ResetPasswordUsecases(authRepository: authRepository);
});

class ResetPasswordUsecases
    implements UsecaseWithParams<bool, ResetPasswordUsecasesParams> {
  final IAuthRepository _authRepository;

  const ResetPasswordUsecases({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(ResetPasswordUsecasesParams params) {
    
    return _authRepository.resetPassword(params.token, params.newPassword);
  }
}
