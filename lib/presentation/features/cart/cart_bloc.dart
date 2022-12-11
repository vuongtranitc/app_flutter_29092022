import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:appp_sale_29092022/data/repositories/cart_repository.dart';
import 'package:appp_sale_29092022/data/repositories/product_repository.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_event.dart';

class CartBloc extends BaseBloc{
  final StreamController<List<Products>> _productsStreamController = StreamController();
  final StreamController<int> _statusStreamController = StreamController();
  final StreamController<int> _totalCartStreamController = StreamController();
  final StreamController<bool> _statusUpdateCartController = StreamController();
  Stream<List<Products>> get productsStream => _productsStreamController.stream;
  Stream<int> get statusStream => _statusStreamController.stream;
  Stream<int> get totalCartStream => _totalCartStreamController.stream;
  Stream<bool> get statusUpdateCartStream => _statusUpdateCartController.stream;
  final CartRepository _repo = CartRepository();


  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType){
      case GetCartEvent:
        _getCart();
        break;
      case UpdateItemCartEvent:
        _updateCart(event as UpdateItemCartEvent);
        break;
    }
  }

  void _updateCart(UpdateItemCartEvent event) async{
    loadingSink.add(true);
    var result = _repo.UpdateCart(event.productId, event.cartId, event.quantity);
    result.then( (_) {
      dispatch(GetCartEvent());
      Future.delayed(const Duration(seconds: 1), () => loadingSink.add(false));
    }
        ,onError: (err){
          messageSink.add(err);
          loadingSink.add(false);
        }
    );
  }

  void _getCart() async{
    loadingSink.add(true);
    var products = _repo.getCartProducts();

    products.then((res) {
      int totalMoney=0;
      List<Products> prods = res;
      if(prods.isNotEmpty){
        for(var i=0; i<prods.length;i++){
          totalMoney += (prods[i].price ?? 0) * (prods[i].quantity ?? 0);
        }
      }
      _productsStreamController.sink.add(res);
      _totalCartStreamController.sink.add(totalMoney);
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
    _totalCartStreamController.close();
    _statusUpdateCartController.close();
  }

}