import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/auth/data/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecasesParam extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String userType;

  const RegisterUsecasesParam({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.userType
  });
  @override
  List<Object?> get props => [fullName, email, password, confirmPassword,userType];
}

// Provider for register usecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecasesParam> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecasesParam params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      userType: params.userType
    );

    return _authRepository.registerUser(entity);
  }
}
