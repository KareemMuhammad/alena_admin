import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

Widget customAppBar(BuildContext context){
  return AppBar(
      iconTheme: IconThemeData(
        color: white, //change your color here
      ),
      backgroundColor: button,
      elevation: 2,
      centerTitle: true,
    title: Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 6, 2),
      child: Image.asset("assets/logo.png",fit: BoxFit.cover,height: 70,width: 70,),
    ),
    actions: [
      IconButton(
        onPressed: (){
          BlocProvider.of<AuthCubit>(context).signOut();
          BlocProvider.of<AdminsCubit>(context).emit(AdminInitial());
        },
        icon: Icon(Icons.logout),
        iconSize: 25,
        color: white,
      ),
    ],
  );
}

Widget loadProductShimmer(){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: white,
      elevation: 4,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            MyShimmer.rectangular(height: 130,),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyShimmer.rectangular(height: 13,width: 60,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyShimmer.rectangular(height: 25,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyShimmer.circular(width: 65,height: 65,),
            ),
          ],
        ),
      ),
    ),
  );
}

InputDecoration textInputDecorationSign(String hintText,IconData iconData){
  return InputDecoration(
    filled: true,
    fillColor: white,
    hintTextDirection: TextDirection.rtl,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY'),
    border: InputBorder.none,
    errorStyle: TextStyle(color: Colors.grey[700],fontSize: 16),
    contentPadding: EdgeInsets.all(8),
    prefixIcon: Icon(iconData,size: 20,color: container,),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white, width: 2.0),
      borderRadius: BorderRadius.circular(20)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white, width: 2.0),
        borderRadius: BorderRadius.circular(20)
    ),
  );
}

InputDecoration textInputDecoration2(String hint) => InputDecoration(
  fillColor: white,
  filled: true,
  hintTextDirection: TextDirection.rtl,
  errorStyle: TextStyle(color: white,fontSize: 16),
  contentPadding: EdgeInsets.all(12.0),
  hintText: hint,
  hintStyle: TextStyle(color: black,fontSize: 17,fontFamily: 'AA-GALAXY'),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: button, width: 2.0),
    borderRadius: BorderRadius.circular(20)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: button, width: 2.0),
      borderRadius: BorderRadius.circular(20)
  ),
);

final spinKit = Center(
  child: SpinKitThreeBounce(
    color: button,
    size: 50.0,
  ),
);



