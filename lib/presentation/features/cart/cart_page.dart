
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/data/model/cart_result_model.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_comform.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
      body: CartContainer()
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
  late HomeBloc homeBloc;
  String cartId = AppCache.getString(VariableConstant.cartId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CartBloc();
    homeBloc = HomeBloc();
    bloc.eventSink.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 12,
              child: StreamBuilder<List<Products>>(
                  initialData: const [],
                  stream: bloc.productsStream,
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return  Container();
                      case ConnectionState.active:
                        if(snapshot.data?.length==0)
                          return Center(
                            child: Column(
                              children: [
                                Expanded(child: Container(), flex: 1,),
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Text("Chi tiết đơn hàng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                          const Text("Giỏ hàng của bạn chưa có sản phẩm", style: TextStyle(color: Colors.green),),
                                          Container(
                                            child: Image.asset("assets/images/img-cart-empty.png"),
                                            padding: EdgeInsets.only(top: 30),
                                          )
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          );
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context,index){
                            return _cartBuilder(snapshot.data?[index]);
                          },
                        );
                      default:
                        return Container();
                    }
                  }),
            ),
            Expanded(
                flex: 2,
                child: StreamBuilder<int>(
                  stream: bloc.totalCartStream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data == 0 )
                        return Container();
                      return Container(
                          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
                          child: Column(
                            children: [
                              Expanded(child: Row(
                                children: [
                                  const Expanded(child: Text("Tổng tiền: ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text("${formatPrice(snapshot.data ?? 0)}đ",
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                                          )
                                      )
                                  ),
                                ],
                              ),),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 30, right: 30),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.orange),
                                    ),
                                    child: TextButton(
                                      child: const Text("Tạo đơn hàng", textAlign: TextAlign.center,),
                                      onPressed: () {
                                        var res = bloc.confirmCartAsync(ConfirmCart(cartId: cartId));
                                        res.then((value) {
                                          if(value){
                                            AppCache.setString(key: VariableConstant.cartId,value: "cartId");
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (BuildContext context) => const CartConform()),
                                                ModalRoute.withName('/')
                                            );
                                          }
                                        });
                                      },
                                    )
                                  )
                              )
                            ],
                          )
                      );
                    }else{
                      if(snapshot.hasError){
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                    }
                    return Container();
                  },
                )
            ),
          ],
        ),
        LoadingWidget(child: Container(), bloc: bloc)
      ],
    );
  }



  Widget? _cartBuilder(Products? item){
    if(item == null)
      return Container(

      );
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
                  width: 130, height: 130,fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                      children: [
                        Expanded(child: Text(item?.name ?? "N/A")),
                        Expanded(
                            child: Text("${formatPrice(item.price ?? 0)} đ",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                  child: OutlinedButton(
                                    child: const Icon(Icons.remove),
                                    onPressed: (){
                                      int quantity = (item.quantity ?? 0) - 1;
                                      bloc.eventSink.add(UpdateItemCartEvent(productId: item.sId ?? "", cartId: cartId, quantity: quantity));
                                    },
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
                                    onPressed: (){
                                      print(cartId);
                                      int quantity = (item.quantity ?? 0) + 1;
                                      bloc.eventSink.add(UpdateItemCartEvent(productId: item.sId ?? "", cartId: cartId, quantity: quantity));
                                    },
                                  )
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

  Widget _loadingWidget(){
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: const SpinKitPouringHourGlass(
          color: Colors.white,
        ),
      ),
    );
  }

}

