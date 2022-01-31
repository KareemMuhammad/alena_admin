import 'package:alena_admin/database/order/order_cubit.dart';
import 'package:alena_admin/database/order/order_state.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  final Vendor vendor;

  const OrdersScreen({Key key, this.vendor}) : super(key: key);
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    BlocProvider.of<OrderCubit>(context).loadMyOrders(widget.vendor.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: black,)),
        title: Text("قائمة الطلبات", style: TextStyle(color: black,fontSize: 20,fontFamily: 'AA-GALAXY'),),
      ),
      body: BlocConsumer<OrderCubit,OrderState>(
        listener: (ctx,state){

        },
        builder: (ctx,state){
          if(state is OrdersLoaded){
            return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (ctx,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                    child: OrderWidget(orderModel: state.orders[index],),
                  );
                });
          }else{
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (ctx,index){
                  return loadProductShimmer();
                });
          }
        },
      ),
    );
  }
}
