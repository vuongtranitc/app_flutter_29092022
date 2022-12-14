import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartHistoryDetailPage extends StatefulWidget {

  CartHistoryDetailPage({Key? key}) : super(key: key);

  @override
  State<CartHistoryDetailPage> createState() => _CartHistoryDetailPageState();
}

class _CartHistoryDetailPageState extends State<CartHistoryDetailPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order detail"),),
      body: _CartHistoryDetailContainer(),
    );
  }
}

class _CartHistoryDetailContainer extends StatefulWidget {


  @override
  State<_CartHistoryDetailContainer> createState() => _CartHistoryDetailContainerState();
}

class _CartHistoryDetailContainerState extends State<_CartHistoryDetailContainer> {

  @override
  Widget build(BuildContext context) {

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    List<Products> prods = arg["products"] as List<Products>;
    int totalPrice = arg["totalPrice"] as int;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 14,
              child: ListView.builder(
                itemCount: prods.length,
                itemBuilder: (context, index) {
                  return _builderCart(prods[index]);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tổng tiền của đơn hàng", style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Text("${formatPrice(totalPrice)} VND", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget? _builderCart(Products prod){
    if(prod==null)
      return Container();
    return Container(
      height:130,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network( "${VariableConstant.apiUrl}/${prod.img}",
                  width: 130, height: 130,fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                              child: Text(prod.name ?? "n/a", maxLines: 2,overflow: TextOverflow.ellipsis,),
                              alignment: Alignment.centerLeft,
                            )
                        ),
                        Expanded(
                            child: Container(
                              child: Text("${formatPrice(prod.price ?? 0)} VND"),
                              alignment: Alignment.centerLeft,
                            )
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text("Số lượng: ${prod.quantity}"),
                                  alignment: Alignment.centerLeft,
                                ),
                                flex: 4,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}

