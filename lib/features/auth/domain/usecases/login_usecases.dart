import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/auth/data/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUsecasesParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecasesParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Provider for login usecase
final loginUsecasesProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase
    implements UsecaseWithParams<AuthEntity, LoginUsecasesParams> {
  final IAuthRepository _authRepository;

  const LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, AuthEntity>> call(params) {
    return _authRepository.loginUser(params.email, params.password);
  }
}
