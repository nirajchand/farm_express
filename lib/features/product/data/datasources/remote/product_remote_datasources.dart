import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/product/data/datasources/product_datasources.dart';
import 'package:farm_express/features/product/data/models/product_api_model.dart';
import 'package:farm_express/features/product/data/models/product_fetch_model.dart';
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
  Future<bool> deleteProduct(String productId) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.delete(
      ApiEndpoints.deleteProduct(productId),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.data["success"] == true) {
      return true;
    }
    return false;
  }

  @override
  Future<ProductWithPagination> getAllProducts({
    required int page,
    required int size,
    String? search,
  }) async {
    final token = await _tokenService.getToken();

    final responseJson = await _apiClient.get(
      ApiEndpoints.getAllProducts(page: page, size: size, search: search),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = responseJson.data['data'] as List;
    final paginationJson = responseJson.data["pagination"];
    final pagination = Pagination.fromJson(paginationJson);

    final products = data
        .map((json) => ProductFetchModel.fromJson(json))
        .toList();

    return ProductWithPagination(products: products, pagination: pagination);
  }

  @override
  Future<List<ProductApiModel>> getProductsByFarmerId() async {
    final token = await _tokenService.getToken();

    final reponseJson = await _apiClient.get(
      ApiEndpoints.getProductsByFarmerId,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = reponseJson.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateProduct(
    ProductApiModel data,
    String productId,
    File? image,
  ) async {
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

    final response = await _apiClient.put(
      ApiEndpoints.updateProduct(productId),
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data["success"];
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
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final responseData = ProductApiModel.fromJson(response.data['data']);
    return responseData;
  }
}
