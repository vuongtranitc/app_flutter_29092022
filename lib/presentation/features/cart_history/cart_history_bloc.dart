import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/data/model/cart_history_model.dart';
import 'package:appp_sale_29092022/data/repositories/cart_repository.dart';
import 'package:appp_sale_29092022/presentation/features/cart_history/cart_history_event.dart';

class CartHistoryBloc extends BaseBloc {
  final CartRepository _repo = CartRepository();
  final StreamController<List<CartHistoryData>> _cartHistoryDataController = StreamController();
  Stream<List<CartHistoryData>> get cartHistoryStream => _cartHistoryDataController.stream;

  @override
  void dispatch(event){
    switch(event.runtimeType){
      case FetchCartHistory:
        _fetchCartHistory();
        break;
    }
  }

  void _fetchCartHistory(){
    loadingSink.add(true);
    _repo.fetchCartHistory().then((res) {
      _cartHistoryDataController.sink.add(res);
      loadingSink.add(false);
    },
      onError: (err){
        messageSink.add(err);
        loadingSink.add(false);
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cartHistoryDataController.close();
  }

}