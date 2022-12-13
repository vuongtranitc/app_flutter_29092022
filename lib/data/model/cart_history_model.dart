import 'package:appp_sale_29092022/data/model/cart_result_model.dart';

class CartHistory {
  int? result;
  List<CartHistoryData>? data;

  CartHistory({this.result, this.data});

  CartHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <CartHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new CartHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartHistoryData {
  String? sId;
  List<Products>? products;
  String? idUser;
  int? price;
  bool? status;
  String? dateCreated;
  int? iV;
  int? productQty;

  CartHistoryData(
      {this.sId,
        this.products,
        this.idUser,
        this.price,
        this.status,
        this.dateCreated,
        this.iV,
        this.productQty});

  CartHistoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    idUser = json['id_user'];
    price = json['price'];
    status = json['status'];
    dateCreated = json['date_created'];
    iV = json['__v'];
    productQty = products?.length ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['id_user'] = this.idUser;
    data['price'] = this.price;
    data['status'] = this.status;
    data['date_created'] = this.dateCreated;
    data['__v'] = this.iV;
    return data;
  }
}
