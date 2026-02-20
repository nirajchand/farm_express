import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/cart/data/datasources/cart.datasources.dart';
import 'package:farm_express/features/cart/data/models/cart_model.dart';
import 'package:farm_express/features/cart/data/models/fetch_cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRemoteDatasourceProvider = Provider<CartRemoteDatasources>((ref) {
  return CartRemoteDatasources(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class CartRemoteDatasources implements ICartRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  const CartRemoteDatasources({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<bool> addProductToCart(CartCreateModel cartCreateModel) async {
    final token = await _tokenService.getToken();

    final responseJson = await _apiClient.post(
      ApiEndpoints.addCart,
      data: cartCreateModel.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final items = responseJson.data["items"];

    if (items != null && items is List && items.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Future<CartFetchModel> getCart() async {
    final token = await _tokenService.getToken();
    return _apiClient
        .get(
          ApiEndpoints.getCart,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .then((responseJson) {
          return CartFetchModel.fromJson(responseJson.data);
        });
  }
}
