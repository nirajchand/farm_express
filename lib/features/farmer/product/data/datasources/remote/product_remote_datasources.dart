import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/farmer/product/data/datasources/product_datasources.dart';
import 'package:farm_express/features/farmer/product/data/models/product_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProductRemoteDataSource implements IProductRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProductRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<void> deleteProduct(String productId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductApiModel>> getProducts() {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductApiModel>> getProductsByFarmerId(String farmerId) {
    throw UnimplementedError();
  }

  @override
  Future<ProductApiModel> updateProduct(ProductApiModel data) {
    throw UnimplementedError();
  }

  @override
  Future<ProductApiModel> addProduct(ProductApiModel data, File? image) async {
    final fileName = image?.path.split("/").last;
    final token = await _tokenService.getToken();

    final formData = FormData.fromMap({
      "farmerId": data.farmerId,
      "productName": data.productName,
      "unitType": data.unitType,
      "status": data.status,
      "description": data.description,
      "price": data.price,
      "quantity": data.quantity,
      if (image != null)
        "product_image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
    });

    final response = await _apiClient.postForm(
      ApiEndpoints.addProducts,
      data: formData,
      options: Options(headers: {
        "Authorization": "Bearer $token",
      }),
    );

    final responseData = ProductApiModel.fromJson(response.data['data']);
    return responseData;
  }
}
