import 'package:equatable/equatable.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntities? cart; 
  final String? errorMessage;
  final bool isDeleting; 

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,  this.isDeleting = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntities? cart,
    String? errorMessage,
    bool? isDeleting,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
