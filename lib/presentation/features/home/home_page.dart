import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/constants/api_constant.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/model/product.dart';
import 'package:appp_sale_29092022/data/repositories/product_repository.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_page.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, ProductRepository>(
          create: (context) => ProductRepository(),
          update: (context, request, repository) {
            repository?.updateApiRequest(request);
            return repository!;
          },
        ),
        ProxyProvider<ProductRepository, HomeBloc>(
          create: (context) => HomeBloc(),
          update: (context, repository, bloc) {
            bloc?.updateProductRepo(repository);
            return bloc!;
          },
        )
      ],
      child: HomeContainer(),
    );
  }
}

class HomeContainer extends StatefulWidget {
  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    bloc.eventSink.add(FetchProductEvent());
    bloc.eventSink.add(LoadCartOnAppbar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Foods App"),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()))
                  .then((value) {
                    bloc.eventSink.add(LoadCartOnAppbar());
                    bloc.loadingSink.add(true);
                    Future.delayed(const Duration(seconds: 1), (){
                      bloc.loadingSink.add(false);
                    });
                  });
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.orange,),
              ),
              Positioned(
                  right: 30,
                  top: 10,
                  child: StreamBuilder<int>(
                    stream: bloc.cartQuantity,
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                          return const Text("...");
                        case ConnectionState.active:
                          return Text((snapshot.data).toString(),
                              style: const TextStyle( color: Colors.white,
                                backgroundColor: Colors.black,
                              ));
                        default:
                          return const Text("");
                      }
                    },)
              )
            ],
          )
        ],
      ),
      body: Stack(
          children: [
            StreamBuilder<List<Product>>(
              initialData: const [],
              stream: bloc.products,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Data is error");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _buildItemFood(snapshot.data?[index]);
                      });
                } else {
                  return Container();
                }
              }),
            LoadingWidget(child: Container(), bloc: bloc)
      ]),
    );
  }

    Widget _buildItemFood(Product? product) {
      if (product == null) return Container();
    return Container(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(ApiConstant.BASE_URL + product.img,
                    width: 150, height: 120, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text("Giá : ${formatPrice(product.price)} đ",
                          style: const TextStyle(fontSize: 12)),
                      ElevatedButton(
                        onPressed: () {
                          bloc.eventSink.add(AddToCartEvent(productId: product.id.toString()));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(200, 240, 102, 61);
                              } else {
                                return const Color.fromARGB(230, 240, 102, 61);
                              }
                            }),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))))),
                        child:
                            const Text("Add To Cart", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
