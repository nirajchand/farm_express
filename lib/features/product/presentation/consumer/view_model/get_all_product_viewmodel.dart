import 'package:farm_express/features/product/domain/usecases/get_all_products_usecases.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllProductViewModelProvider =
    NotifierProvider<GetAllProductsViewModel, GetAllProductState>(
      () => GetAllProductsViewModel(),
    );

class GetAllProductsViewModel extends Notifier<GetAllProductState> {
  late final GetAllproductsUsecases _getAllproductsUsecases;

  @override
  GetAllProductState build() {
    _getAllproductsUsecases = ref.read(getAllProductsUsecasesProvider);
    return const GetAllProductState();
  }

  Future<void> getAllProducts({
    int page = 1,
    int size = 10,
    String? search,
    bool append = false, 
  }) async {
    state = state.copyWith(status: GetAllProductStateStatus.loading);

    final result = await _getAllproductsUsecases.call(
      GetAllUseCasesParams(page: page, size: size, search: search),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetAllProductStateStatus.failure,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          status: GetAllProductStateStatus.success,
          products: append
              ? [...?state.products, ...data.products] 
              : data.products,
          pagination: data.pagination, 
        );
      },
    );
  }
}



