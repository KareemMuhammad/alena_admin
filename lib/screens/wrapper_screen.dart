import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/database/auth_bloc/auth_state.dart';
import 'package:alena_admin/screens/auth/registration.dart';
import 'package:alena_admin/screens/auth/reset_password.dart';
import 'package:alena_admin/screens/auth/setup_screen.dart';
import 'admin_only/alena_admin_screen.dart';
import 'package:alena_admin/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_screen.dart';
import 'auth/login_screen.dart';


class WrapperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return SplashScreen();
        }else if (state is AuthFailure){
          return LoginScreen();
        }else if (state is AuthSuccessful){
          return DashboardScreen(alenaAdmin: state.appUser);
        }else if (state is AuthAdminAlena){
          return AlenaAdminScreen();
        } else if (state is AuthSetup){
          return SetupScreen(vendor: state.vendor,);
        }else if (state is AuthRegistration){
          return RegistrationScreen();
        }else if (state is AuthPasswordReset){
          return PasswordReset();
        }else{
          return const SizedBox();
        }
      },
    );
  }
}
