import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
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

}