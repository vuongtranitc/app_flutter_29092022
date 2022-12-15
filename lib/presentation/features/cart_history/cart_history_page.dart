import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/data/model/cart_history_model.dart';
import 'package:appp_sale_29092022/presentation/features/cart_history/cart_history_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/cart_history/cart_history_event.dart';
import 'package:appp_sale_29092022/presentation/features/cart_history_detail/cart_history_detail_page.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartHistoryPage extends StatefulWidget {
  const CartHistoryPage({Key? key}) : super(key: key);

  @override
  State<CartHistoryPage> createState() => _CartHistoryPageState();

}

class _CartHistoryPageState extends State<CartHistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart History"),),
      body: _CartHistoryContainer(),
    );
  }
}

class _CartHistoryContainer extends StatefulWidget {
  const _CartHistoryContainer({Key? key}) : super(key: key);

  @override
  State<_CartHistoryContainer> createState() => _CartHistoryContainerState();
}

class _CartHistoryContainerState extends State<_CartHistoryContainer> {

  late CartHistoryBloc bloc;
  late HomeBloc homeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CartHistoryBloc();
    homeBloc = HomeBloc();
    bloc.eventSink.add(FetchCartHistory());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: bloc.cartHistoryStream,
      builder: (context, snapshot) {
        if(snapshot.data?.length==0){
          return _notHasOrder();
        }
        return Stack(
          children: [
            Container(
              child: ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return _builderCard(snapshot.data?[index]);
                },
              ),
            ),
            LoadingWidget(child: Container(), bloc: bloc)
          ],
        );
      }
    );
  }

  Widget _builderCard(CartHistoryData? cartHistory){
    if(cartHistory == null)
      return Container();
    return Container(
      height: 90,
      child: Card(
        elevation: 2,
        shadowColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartHistory.dateCreated == null ? "" : formatDate(cartHistory.dateCreated.toString())),
                      const SizedBox(height: 10,),
                      Text("Tổng tiền: ${formatPrice(cartHistory?.price ?? 0)} VND")
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => CartHistoryDetailPage()));
                            Navigator.pushNamed(
                              context,
                              "cart-history-detail",
                              arguments: {
                                'products': cartHistory.products,
                                'totalPrice': cartHistory.price
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.keyboard_arrow_right),
                                  Text("Chi tiết")
                                ],
                              )
                            ],
                          ),
                          )
                        ],
                      )
                    ],
                  )
              )
            ],
            )
          ),
        ),
    );
  }

  Widget _notHasOrder(){
    return Stack(
      children: [
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Text("Đơn hàng hiện tại đang trống", style:TextStyle(fontSize: 16),),
                const SizedBox(height: 10,),
                Image.asset("assets/images/img-cart-empty.png", fit: BoxFit.cover,)
              ],
            ),
          ),
        ),
        LoadingWidget(child: Container(), bloc: bloc)
      ]
    );
  }

}

