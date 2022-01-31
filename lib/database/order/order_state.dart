import 'package:alena_admin/models/order.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState{}

class OrderLoading extends OrderState{}

class OrderAdded extends OrderState{}

class OrderNotAdded extends OrderState{}

class OrderLoadError extends OrderState{}

class OrdersLoaded extends OrderState{
  final List<OrderModel> orders;

  OrdersLoaded(this.orders);
}