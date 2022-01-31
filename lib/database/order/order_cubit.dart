import 'package:alena_admin/database/order/order_state.dart';
import 'package:alena_admin/models/order.dart';
import 'package:alena_admin/models/user.dart';
import 'package:bloc/bloc.dart';

import 'order_repository.dart';

class OrderCubit extends Cubit<OrderState>{
  final OrderRepository orderRepository;
  OrderCubit({this.orderRepository}) : super(OrderInitial());

  List<OrderModel> _ordersList;

  Future saveOrder(OrderModel orderModel)async{
    try{
      emit(OrderLoading());
      await orderRepository.saveOrderToDb(orderModel.toMap(), orderModel.getOrderId);
      emit(OrderAdded());
    }catch(e){
      print(e.toString());
      emit(OrderNotAdded());
    }
  }

  Future loadMyOrders(String id)async{
    try {
      emit(OrderLoading());
      _ordersList = await orderRepository.getAllOrdersOfVendor(id);
      if(_ordersList != null) {
        emit(OrdersLoaded(_ordersList));
      }else{
        emit(OrderLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(OrderLoadError());
    }
  }

}