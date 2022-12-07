class CartResult {
  int? result;
  CartData? data;

  CartResult({this.result, this.data});

  CartResult.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CartData {
  String? sId;
  List<Products>? products;
  String? idUser;
  int? price;
  String? dateCreated;
  int? iV;

  CartData(
      {this.sId,
        this.products,
        this.idUser,
        this.price,
        this.dateCreated,
        this.iV});

  CartData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    idUser = json['id_user'];
    price = json['price'];
    dateCreated = json['date_created'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['id_user'] = this.idUser;
    data['price'] = this.price;
    data['date_created'] = this.dateCreated;
    data['__v'] = this.iV;
    return data;
  }
}

class Products {
  String? sId;
  String? name;
  String? address;
  int? price;
  String? img;
  int? quantity;
  List<String>? gallery;
  String? dateCreated;
  Null? dateUpdated;
  int? iV;

  Products(
      {this.sId,
        this.name,
        this.address,
        this.price,
        this.img,
        this.quantity,
        this.gallery,
        this.dateCreated,
        this.dateUpdated,
        this.iV});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'].cast<String>();
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['price'] = this.price;
    data['img'] = this.img;
    data['quantity'] = this.quantity;
    data['gallery'] = this.gallery;
    data['date_created'] = this.dateCreated;
    data['date_updated'] = this.dateUpdated;
    data['__v'] = this.iV;
    return data;
  }
}