import 'package:farm_express/features/cart/data/models/cart_model.dart';
import 'package:farm_express/features/cart/data/models/fetch_cart_model.dart';

abstract interface class ICartRemoteDataSource {
  Future<CartFetchModel> getCart();
  Future<bool> addProductToCart(CartCreateModel cartCreateModel);
  Future<bool> removeProductFromCart(String productId);
  Future<CartFetchModel> updateCart(String productId, double quantity);
}
