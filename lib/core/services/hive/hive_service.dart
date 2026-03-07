import 'package:farm_express/core/constants/hive_table_constant.dart';
import 'package:farm_express/features/auth/data/models/auth_hive_model.dart';
import 'package:farm_express/features/consumer_profile/data/models/consumer_profile_hive_model.dart';
import 'package:farm_express/features/farmer_profile/data/models/farmer_profile_hive_model.dart';
import 'package:farm_express/features/product/data/models/product_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await _openBoxes();
  }

  // Initialize image cache
  Future<void> initImageCache() async {
    // Image cache initialization will happen on first use
    // This is just a placeholder for potential future setup
  }

  // register all types of adapters
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.productTypeId)) {
      Hive.registerAdapter(ProductHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.farmerProfileTypeId)) {
      Hive.registerAdapter(FarmerProfileHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.consumerProfileTypeId)) {
      Hive.registerAdapter(ConsumerProfileHiveModelAdapter());
    }
  }

  // open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTableName);
    await Hive.openBox<ProductHiveModel>(HiveTableConstant.productTableName);
    await Hive.openBox<FarmerProfileHiveModel>(
      HiveTableConstant.farmerProfileTableName,
    );
    await Hive.openBox<ConsumerProfileHiveModel>(
      HiveTableConstant.consumerProfileTableName,
    );
  }

  // close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ===================== Auth operations =====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTableName);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // ===================== Product operations =====================
  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>(HiveTableConstant.productTableName);

  // Save all products to Hive
  Future<void> saveProducts(List<ProductHiveModel> products) async {
    await _productBox.clear();
    for (var product in products) {
      await _productBox.put(product.id, product);
    }
  }

  // Get all cached products
  Future<List<ProductHiveModel>> getAllProducts() async {
    return _productBox.values.toList();
  }

  // Get a single product by ID
  Future<ProductHiveModel?> getProduct(String productId) async {
    return _productBox.get(productId);
  }

  // Clear all products
  Future<void> clearProducts() async {
    await _productBox.clear();
  }

  // ===================== Farmer Profile operations =====================
  Box<FarmerProfileHiveModel> get _farmerProfileBox =>
      Hive.box<FarmerProfileHiveModel>(
        HiveTableConstant.farmerProfileTableName,
      );

  // Save farmer profile
  Future<void> saveFarmerProfile(FarmerProfileHiveModel profile) async {
    await _farmerProfileBox.put('farmer_profile', profile);
  }

  // Get farmer profile
  Future<FarmerProfileHiveModel?> getFarmerProfile() async {
    return _farmerProfileBox.get('farmer_profile');
  }

  // Clear farmer profile
  Future<void> clearFarmerProfile() async {
    await _farmerProfileBox.clear();
  }

  // ===================== Consumer Profile operations =====================
  Box<ConsumerProfileHiveModel> get _consumerProfileBox =>
      Hive.box<ConsumerProfileHiveModel>(
        HiveTableConstant.consumerProfileTableName,
      );

  // Save consumer profile
  Future<void> saveConsumerProfile(ConsumerProfileHiveModel profile) async {
    await _consumerProfileBox.put('consumer_profile', profile);
  }

  // Get consumer profile
  Future<ConsumerProfileHiveModel?> getConsumerProfile() async {
    return _consumerProfileBox.get('consumer_profile');
  }

  // Clear consumer profile
  Future<void> clearConsumerProfile() async {
    await _consumerProfileBox.clear();
  }
}
