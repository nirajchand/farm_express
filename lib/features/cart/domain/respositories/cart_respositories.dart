

import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';

abstract class ICartRepositories{
  Future<Either<Failure,CartEntities>> getCart();
  Future<Either<Failure,bool>> addProductToCart(CartEntities cartCreateEntities);
}