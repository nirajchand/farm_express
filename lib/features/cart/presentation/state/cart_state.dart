import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  final CartStatus status;
  final List<CartEntities>? cart;
  final String? errorMessage;

  CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    List<CartEntities>? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}