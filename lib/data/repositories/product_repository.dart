import 'dart:async';

import 'package:appp_sale_29092022/common/constants/api_constant.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {

  Dio _dio = Dio();

  late ApiRequest _apiRequest;

  void updateApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<AppResource<List<ProductDTO>>> getProducts() async{
    Completer<AppResource<List<ProductDTO>>> completer = Completer();
    try {
      Response<dynamic> response =  await _apiRequest.getProducts();
      // TODO: Improve use Isolate
      AppResource<List<ProductDTO>> resourceProductDTO = AppResource.fromJson(response.data, (listData){
        return (listData as List).map((e) => ProductDTO.fromJson(e)).toList();
      });
      completer.complete(resourceProductDTO);
    } on DioError catch (dioError) {
      completer.completeError(dioError.response?.data["message"]);
    } catch(e) {
      completer.completeError(e.toString());
    }
    return completer.future;
  }

  Future<List<Products>> getCartProducts() async{
    String apiUrl = "${VariableConstant.apiUrl}/cart";
    String token = AppCache.getString(VariableConstant.TOKEN);
    _dio.options.headers["Authorization"] = "Bearer $token";
    try {

      Response response =  await _dio.get(apiUrl);

      // TODO: Improve use Isolate


      CartData cartData = CartData.fromJson((response.data["data"]));
      List<Products>? products = cartData.products;

      return products ?? [];

    } on DioError catch (dioError) {
      return [];
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

}