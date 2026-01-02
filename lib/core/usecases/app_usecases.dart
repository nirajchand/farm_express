
import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';

abstract interface class UsecaseWithParams<SuccessType,params>{
  Future<Either<Failure,SuccessType>> call(params params);
}

abstract interface class UseecaseWithoutParams<SuccessType>{
  Future<Either<Failure,SuccessType>> call();
}