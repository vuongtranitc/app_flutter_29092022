import 'package:appp_sale_29092022/common/bases/base_event.dart';

class CartEvent extends BaseEvent{

  @override
  List<Object?> get props => [];

}

class GetCartEvent extends BaseEvent{
  @override
  List<Object?> get props => [];
}

class UpdateItemCartEvent extends BaseEvent{

  late String productId;
  late String cartId;
  late int quantity;

  UpdateItemCartEvent({required this.productId, required this.cartId, required this.quantity});

  @override
  List<Object?> get props => [];
}
