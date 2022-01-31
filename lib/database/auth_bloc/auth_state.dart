import 'package:alena_admin/models/vendor.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState{}

class AuthFailure extends AuthState{}

class AuthAdminAlena extends AuthState{}

class AuthRegistration extends AuthState{}

class AuthPasswordReset extends AuthState{}

class AuthSetup extends AuthState{
 final Vendor vendor;

  AuthSetup(this.vendor);
}

class AuthSuccessful extends AuthState{
 final Vendor appUser;

 AuthSuccessful(this.appUser);
}