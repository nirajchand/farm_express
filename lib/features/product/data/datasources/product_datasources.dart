
import 'dart:io';

import 'package:farm_express/features/product/data/models/product_api_model.dart';
import 'package:farm_express/features/product/data/models/product_fetch_model.dart';

abstract interface class IProductRemoteDataSource {
  Future<ProductApiModel> addProduct(ProductApiModel data, File? image);
  Future<List<ProductFetchModel>> getAllProducts();
  Future<ProductApiModel> updateProduct(ProductApiModel data);
  Future<void> deleteProduct(String productId);
  Future<List<ProductApiModel>> getProductsByFarmerId();
}