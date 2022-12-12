import 'package:appp_sale_29092022/presentation/features/home/home_page.dart';
import 'package:flutter/material.dart';

class CartConform extends StatelessWidget {
  const CartConform({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart Conform",textAlign: TextAlign.center,),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Xin cám ơn", style: TextStyle(fontSize: 20,color: Colors.green),),
              const Text("Cám ơn bạn đã mua hàng, chúng tôi sẽ liên hệ lại với bạn trong thời gian sớm nhất"),
              TextButton(onPressed: (){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
                    ModalRoute.withName('/')
                );
              }, child: Text("Quay lại trang chủ"))
            ],
          ),
        ),
      ),
    );
  }
}
