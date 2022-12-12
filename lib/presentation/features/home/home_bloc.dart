import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:appp_sale_29092022/data/model/product.dart';
import 'package:appp_sale_29092022/data/repositories/cart_repository.dart';
import 'package:appp_sale_29092022/data/repositories/product_repository.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_event.dart';
import 'package:flutter/cupertino.dart';

class HomeBloc extends BaseBloc {
  final ProductRepository _repo = ProductRepository();
  final CartRepository _cartRepo = CartRepository();
  final StreamController<List<Product>> _listProductsController = StreamController();
  final StreamController<int> _cartQuantityStreamController = StreamController<int>();
  final StreamController<bool> _statusAddToCartController = StreamController<bool>();
  Stream<List<Product>> get products => _listProductsController.stream;
  Stream<int> get cartQuantity => _cartQuantityStreamController.stream;
  Stream<bool> get getStatusAddToCart => _statusAddToCartController.stream;
  late int cartQty;

  HomeBloc(){
    ProductRepository repo;
    repo = _repo;
  }

  late ProductRepository _productRepository;

  void updateProductRepo(ProductRepository productRepository) {
    _productRepository = productRepository;
  }


  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchProductEvent:
        _executeGetProducts(event as FetchProductEvent);
        break;
      case LoadCartOnAppbar:
        _getCartOnAppbar();
        break;
      case AddToCartEvent:
        _addToCart(event as AddToCartEvent);
    }
  }

  void _executeGetProducts(FetchProductEvent event) async{
    loadingSink.add(true);
    try {
      AppResource<List<ProductDTO>> resourceProductDTO = await _productRepository.getProducts();
      if (resourceProductDTO.data == null) return;
      List<ProductDTO> listProductDTO = resourceProductDTO.data ?? List.empty();
      List<Product> listProduct = listProductDTO.map((e){
        return Product(e.id, e.name, e.address, e.price, e.img, e.quantity, e.gallery);
      }).toList();
      _listProductsController.sink.add(listProduct);
      loadingSink.add(false);
    } catch (e) {
      messageSink.add(e.toString());
      loadingSink.add(false);
    }
  }

  void _getCartOnAppbar() async{
    String cartId = AppCache.getString(VariableConstant.cartId);

    if(cartId.isEmpty || cartId == "cartId"){
      var getCartId = _cartRepo.getCartId();
      getCartId.then( (res) {
        AppCache.setString(key: VariableConstant.cartId,value: res);
      },
        onError: (err) => cartId = "cartId"
      );
    }

    var products = _cartRepo.getCartProducts();
    _statusAddToCartController.add(true);
    products.then((res) {
      List<Products> items = res;
      int count=0;
      if(items.isNotEmpty){
        for(var i=0; i<items.length;i++){
          count+=items[i].quantity ?? 0;
        }
      }
      _cartQuantityStreamController.sink.add(count);
      _statusAddToCartController.add(false);

    },
        onError: (err) {
          messageSink.add(err.toString());
          _statusAddToCartController.add(false);
        });

  }


  void _addToCart(AddToCartEvent event){
    if(event.productId.isEmpty){
      //_streamAddToCartController.sink.addError("error");
      messageSink.add("productId is empty");
      return;
    }
    loadingSink.add(true);
    _cartRepo.addToCart(event.productId).then((res) {
      dispatch(LoadCartOnAppbar());
      Future.delayed(const Duration(seconds: 1), () {
        loadingSink.add(false);
      });
    }
        , onError:  (err) => messageSink.add(err.toString()));
  }

  @override
  void dispose() {
    super.dispose();
    _listProductsController.close();
    _cartQuantityStreamController.close();
    _statusAddToCartController.close();
  }
}