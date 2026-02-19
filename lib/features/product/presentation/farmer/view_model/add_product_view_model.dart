import 'package:farm_express/features/product/domain/usecases/add_product_usecases.dart';
import 'package:farm_express/features/product/domain/usecases/get_allProducts_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/state/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductViewModelProvider =
    NotifierProvider<AddProductViewModel, ProductState>(
      () => AddProductViewModel(),
    );

class AddProductViewModel extends Notifier<ProductState> {
  late final AddProductUsecases _addProductUsecases;
  late final GetAllproductsUsecases _getAllproductsUsecases;

  @override
  ProductState build() {
    _addProductUsecases = ref.read(addProductUsecasesProvider);
    _getAllproductsUsecases = ref.read(getAllProductsUsecasesProvider);
    return ProductState();
  }

  Future<void> addProduct(AddProductUseCaseParams data) async {
    state = state.copyWith(status: ProductStateStatus.loading);
    final result = await _addProductUsecases.call(data);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStateStatus.failure,
          errorMessage: failure.message,
        );
      },
      (productData) {
        state = state.copyWith(
          status: ProductStateStatus.success,
          product: productData,
        );
      },
    );
  }

  Future<void> getAllProducts() async {
    state = state.copyWith(status: ProductStateStatus.loading);
    final result = await _getAllproductsUsecases.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStateStatus.failure,
          errorMessage: failure.message,
        );
      },
      (productsData) {
        state = state.copyWith(
          status: ProductStateStatus.success,
          product: productsData,
        );
      },
    );
  }
}
