import 'package:equatable/equatable.dart';

class AddCartEntity extends Equatable {
  final String? productId;
  final int? quantity;

  const AddCartEntity({
     this.productId,
     this.quantity,
  });
  
  @override
  List<Object?> get props => [productId, quantity];
}