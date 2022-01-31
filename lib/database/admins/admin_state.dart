import 'package:alena_admin/models/vendor.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState{}

class AdminLoading extends AdminState{}

class AdminLoadError extends AdminState{}

class AdminAlenaIn extends AdminState{}

class VendorPassReset extends AdminState{}

class AdminLoaded extends AdminState{
  final Vendor appAdmin;

  AdminLoaded(this.appAdmin);
}