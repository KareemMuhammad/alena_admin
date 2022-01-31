import 'package:alena_admin/models/vendor.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RegState {}

class RegInitial extends RegState{}

class RegLoading extends RegState{}

class RegLoadError extends RegState{}

class RegUserLoaded extends RegState{
 final Vendor appUser;

  RegUserLoaded(this.appUser);
}