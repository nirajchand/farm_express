// Provider for login usecase
import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/core/usecases/app_usecases.dart';
import 'package:farm_express/features/auth/data/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendTokenProvider = Provider<SendTokenUsecases>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SendTokenUsecases(authRepository: authRepository);
});


class SendTokenUsecases
    implements UsecaseWithParams<bool, String> {
  final IAuthRepository _authRepository;

  const SendTokenUsecases({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(String email) {
    return _authRepository.sendToken(email);
  }
}
