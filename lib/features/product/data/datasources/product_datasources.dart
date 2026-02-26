import 'dart:io';

import 'package:farm_express/features/product/data/models/product_api_model.dart';
import 'package:farm_express/features/product/data/models/product_fetch_model.dart';

abstract interface class IProductRemoteDataSource {
  Future<ProductApiModel> addProduct(ProductApiModel data, File? image);
  Future<ProductWithPagination> getAllProducts({
    required int page,
    required int size,
    String? search,
  });
  Future<bool> updateProduct(ProductApiModel data, String productId,File? image);
  Future<bool> deleteProduct(String productId);
  Future<List<ProductApiModel>> getProductsByFarmerId();
}
