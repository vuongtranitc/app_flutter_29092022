import 'package:appp_sale_29092022/common/constants/api_constant.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart"),),
      body: CartContainer(),
    );
  }
}

class CartContainer extends StatefulWidget {
  const CartContainer({Key? key}) : super(key: key);

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {

  late CartBloc bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CartBloc();
    bloc.eventSink.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Products>>(
        initialData: const [],
        stream: bloc.productsStream,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Container(
              child: const Text("Loi khi load data"),
            );
          }else{
            if(snapshot.hasData){
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context,index){
                    return _cartBuilder(snapshot.data?[index]);
                  },
                ),
              );
            }else{
              return Container();
            }
          }
        });
  }

  Widget? _cartBuilder(Products? item){
    if(item == null)
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
                child: Image.network( "${VariableConstant.apiUrl}/${item?.img}",
                  width: 130, height: 130,fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                      children: [
                        Expanded(child: Text(item?.name ?? "N/A")),
                        const Expanded(child: Text("20.000 vnd")),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                  child: OutlinedButton(
                                    child: const Icon(Icons.remove),
                                    onPressed: (){},
                                  )
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15,right: 15),
                                  child: Text(item?.quantity.toString() ?? ""),
                                  alignment: Alignment.center,
                                ),
                                flex: 4,
                              ),
                              Expanded(
                                  flex: 3,
                                  child: OutlinedButton(
                                    child: const Icon(Icons.add),
                                    onPressed: (){},
                                  )
                              )
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

