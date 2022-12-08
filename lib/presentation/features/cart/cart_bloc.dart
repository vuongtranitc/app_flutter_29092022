import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:appp_sale_29092022/data/repositories/product_repository.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';

class CartBloc extends BaseBloc{
  final StreamController<List<Products>> _productsStreamController = StreamController();
  final StreamController<int> _statusStreamController = StreamController();
  Stream<List<Products>> get productsStream => _productsStreamController.stream;
  Stream<int> get statusStream => _statusStreamController.stream;
  ProductRepository _repo = ProductRepository();


  CartBloc(){
    ProductRepository repo = ProductRepository();
    _repo = repo;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType){
      case GetCartEvent:
        _getCart();
        break;
    }
  }

  void _getCart() async{
    loadingSink.add(true);
    var products = _repo.getCartProducts();

    products.then((res) {
      _productsStreamController.sink.add(res);
      loadingSink.add(false);

    },
        onError: (err) {
          messageSink.add(err.toString());
          loadingSink.add(false);
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productsStreamController.close();
    _statusStreamController.close();
  }

}