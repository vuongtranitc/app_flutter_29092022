import 'package:appp_sale_29092022/common/bases/base_event.dart';

class FetchProductEvent extends BaseEvent {
  @override
  List<Object?> get props => [];

}

class LoadCartOnAppbar extends BaseEvent{
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends BaseEvent{

  late String productId;

  AddToCartEvent({required this.productId});

  @override
  List<Object?> get props => [];
}