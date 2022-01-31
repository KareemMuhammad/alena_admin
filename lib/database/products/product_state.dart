import 'package:alena_admin/models/product.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState{}

class ProductLoading extends ProductState{}

class ProductAddedToWait extends ProductState{}

class ProductDeleted extends ProductState{}

class ProductDeleteError extends ProductState{}

class WaitingProductAdded extends ProductState{}

class ProductUpdated extends ProductState{}

class ProductNotUpdated extends ProductState{}

class ProductLoadError extends ProductState{}

class ProductLoaded extends ProductState{
  final List<Product> products;

  ProductLoaded(this.products);
}