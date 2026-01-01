import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/auth/data/datasources/auth_datasource.dart';
import 'package:farm_express/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:farm_express/features/auth/data/models/auth_hive_model.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(authDatasource: ref.read(authLocalDatasourceProvider));
});

class AuthRepository implements IAuthRepository {

  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;
  @override
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password) async{
    try{
      final user = await _authDatasource.loginUser(email, password);
      if(user != null){
        final entity = user.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: "Email or password is incorrect"));
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerUser(AuthEntity user) async {
    try{
      final model = AuthHiveModel.fromEntity(user);
      final result = await _authDatasource.registerUser(model);
      if(result){
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to register user"));
    }catch(e){
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
