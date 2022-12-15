import 'dart:convert';
import 'dart:isolate';

import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/model/cart_history_model.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:dio/dio.dart';

class CartRepository {

  Dio _dio = Dio();

  Future<String> getCartId() async{
    String apiUrl = "${VariableConstant.apiUrl}/cart";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try {

      Response response =  await _dio.get(apiUrl);

      // TODO: Improve use Isolate


      CartData cartData = CartData.fromJson((response.data["data"]));
      String cartId = cartData.sId ?? "";
      return cartId;

    } on DioError catch (dioError) {
      return "";
    } catch(e) {
      return "";
    }
  }

  Future<List<Products>> getCartProducts() async{
    String apiUrl = "${VariableConstant.apiUrl}/cart";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try {

      Response response =  await _dio.get(apiUrl);

      // TODO: Improve use Isolate
      if(response.data["result"] == 0)
        return [];

      CartData cartData = CartData.fromJson((response.data["data"]));
      List<Products>? products = cartData.products;

      return products ?? [];

    } catch(e) {
      return [];
    }
  }

  Future<String> addToCart(String product_id) async{
    String apiUrl ="${VariableConstant.apiUrl}/cart/add";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try {

      Response response =  await _dio.post(apiUrl,data: {'id_product':product_id});

      // TODO: Improve use Isolate

      return "success";

    } on DioError catch (dioError) {
      return dioError.toString();
    } catch(e) {
      return e.toString();
    }
  }

  Future<bool> UpdateCart(String productId, String cartId, int quantity) async{
    String apiURL = "${VariableConstant.apiUrl}/cart/update";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try{
      await _dio.post(apiURL,data: {
        "id_product" : productId,
        "id_cart" : cartId,
        "quantity" : quantity
      });
      return true;
    }
    catch (e){
      return false;
    }

  }

  Future<bool> ConfirmCart(String cartId) async{
      String apiURL = "${VariableConstant.apiUrl}/cart/conform";
      String token = AppCache.getString(VariableConstant.TOKEN);
      _dio.options.headers["Authorization"] = "Bearer $token";
      try{
        await _dio.post(apiURL, data: {
          "id_cart" : cartId,
          "status" : false
        });
        return true;
      }
      catch(e){
        return false;
      }
    }

  Future<List<CartHistoryData>> fetchCartHistory() async{
    String apiUrl ="${VariableConstant.apiUrl}/order/history";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try {
      // TODO: Improve use Isolate
      List<CartHistoryData> res = [];
      Response response =  await _dio.post(apiUrl);
      if(response.data["result"] == 1){
        var cartHistory = CartHistory.fromJson(response.data);
        res = cartHistory.data ?? [];
      }
      return res;
    } catch(e) {
      return [];
    }
  }

  // Improve use Isolate.spawn
  Future<List<CartHistoryData>> getCartHistoryList() async{
    String apiUrl ="${VariableConstant.apiUrl}/order/history";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try{
      Response response =  await _dio.post(apiUrl);
      ReceivePort receivePort = ReceivePort();
      final isolate = await Isolate.spawn(parseCartHistoryData,[receivePort.sendPort , response.data]);
      List<CartHistoryData> res = await receivePort.first;
      isolate.kill(priority: Isolate.immediate);
      return res;
    }
    catch (e){
      return [];
    }
  }

  static void parseCartHistoryData(List<dynamic> param) {
    SendPort sendPort = param[0];
    var cartHistory = CartHistory.fromJson(param[1]);
    var sendData = cartHistory.data ?? [];
    sendPort.send(sendData);
  }


}