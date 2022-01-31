import 'package:flutter/material.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState{}

class CategoryFailure extends CategoryState{}

class CategoryDone extends CategoryState{
  final String category;

  CategoryDone(this.category);
}