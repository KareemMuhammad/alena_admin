import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/database/auth_bloc/auth_state.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  String userNotFound = 'البريد الالكترونى او كلمة السر غير صحيحة!';

  bool isUnCover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: white,
          image: DecorationImage(
            image: AssetImage("assets/app-screen.png"),
            fit: BoxFit.cover,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<AdminsCubit,AdminState>(
          builder: (context, state) {
            return loginScreen(state);
          },
          listener: (ctx,state){
            if(state is AdminLoaded){
              BlocProvider.of<AuthCubit>(context).emit(AuthSuccessful(state.appAdmin));
            }else if(state is AdminAlenaIn){
              BlocProvider.of<AuthCubit>(context).emit(AuthAdminAlena());
            }
          },
        ),
      ),
    );
  }

  Widget loginScreen(AdminState state){
    if( state is AdminInitial ){
      return initialUi(state);
    }else if( state is AdminLoading ){
      return Column(
        children: [
          const SizedBox(height: 80,),
          CircleAvatar(
            radius: 60,
            backgroundColor: white,
            child: Center(
              child: Text('علينا',style: TextStyle(fontSize: 50,color: button,
                  fontFamily: 'AA-GALAXY'),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: spinKit,
          ),
        ],
      );
    }else if( state is AdminLoadError ){
      return failureUi(state);
    }else{
      return Container();
    }
  }

  Widget failureUi(AdminState state){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80,),
          CircleAvatar(
            radius: 60,
            backgroundColor: white,
            child: Center(
              child: Text('علينا',style: TextStyle(fontSize: 50,color: button,
                  fontFamily: 'AA-GALAXY'),),
            ),
          ),
          const SizedBox(height: 40,),
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                      child: TextFormField(
                        style: TextStyle(color: black,fontSize: 18,),
                        decoration: textInputDecorationSign('البريد الالكترونى',Icons.email),
                        controller: emailController,
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                              ? null : 'من فضلك ادخل بريد الكترونى صحيح';
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('كلمة المرور'),
                      controller: passwordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? 'كلمة مرور ضعيفة' : null;
                      },
                    ),
                  ),
                ],
              )
          ),
          Text(userNotFound, style: TextStyle(color: Colors.red[700], fontSize: 17.0),),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){
                  BlocProvider.of<AuthCubit>(context).emit(AuthPasswordReset());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1,8,20,5),
                  child: Text('نسيت كلمة المرور',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),),
                )
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120,vertical: 1),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: button,
              elevation: 2,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async{
                  if(formKey.currentState.validate()){
                    if(passwordController.text == ADMIN_PASS){
                      BlocProvider.of<AdminsCubit>(context).signInAdmin(emailController.text, passwordController.text);
                    }else{
                      BlocProvider.of<AdminsCubit>(context).signInEmailAndPassword(emailController.text, passwordController.text);
                    }
                  }
                },
                child: Text('دخول',style: TextStyle(fontSize: 25,color: white, fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              BlocProvider.of<AuthCubit>(context).emit(AuthRegistration());
            },
            child: RichText(textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: ' مستخدم جديد',
                        style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ),
                    TextSpan(
                        text: '  سجل الان',
                        style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                            ,decoration: TextDecoration.underline)
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget initialUi(AdminState state){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80,),
          CircleAvatar(
            radius: 60,
            backgroundColor: white,
            child: Center(
              child: Text('علينا',style: TextStyle(fontSize: 50,color: button,
                  fontFamily: 'AA-GALAXY'),),
            ),
          ),
          const SizedBox(height: 40,),
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                      child: TextFormField(
                        style: TextStyle(color: black,fontSize: 18,),
                        decoration: textInputDecorationSign('البريد الالكترونى',Icons.email),
                        controller: emailController,
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                              ? null : 'من فضلك ادخل بريد الكترونى صحيح';
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    child: TextFormField(
                      style: TextStyle(color: black,fontSize: 18,),
                      decoration: customDecore('كلمة المرور'),
                      controller: passwordController,
                      obscureText: isUnCover ? false : true,
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? 'كلمة مرور خطأ' : null;
                      },
                    ),
                  ),
                ],
              )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){
                  BlocProvider.of<AuthCubit>(context).emit(AuthPasswordReset());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1,8,20,5),
                  child: Text('نسيت كلمة المرور',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),),
                )
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120,vertical: 1),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: button,
              elevation: 2,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async{
                  if(formKey.currentState.validate()){
                    if(passwordController.text == ADMIN_PASS){
                      BlocProvider.of<AdminsCubit>(context).signInAdmin(emailController.text, passwordController.text);
                    }else{
                      BlocProvider.of<AdminsCubit>(context).signInEmailAndPassword(emailController.text, passwordController.text);
                    }
                  }
                },
                child: Text('دخول',style: TextStyle(fontSize: 25,color: white, fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ),
          const SizedBox(height: 30,),
          InkWell(
            onTap: (){
              BlocProvider.of<AuthCubit>(context).emit(AuthRegistration());
            },
            child: RichText(textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: ' مستخدم جديد',
                        style: TextStyle(color: black,fontSize: 22,fontFamily: 'AA-GALAXY')
                    ),
                    TextSpan(
                        text: '  سجل الان',
                        style: TextStyle(color: Colors.grey[700],fontSize: 22,fontFamily: 'AA-GALAXY'
                            ,decoration: TextDecoration.underline)
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration customDecore(String hint){
    return InputDecoration(
      filled: true,
      fillColor: white,
      hintTextDirection: TextDirection.rtl,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 18,color: button,fontFamily: 'AA-GALAXY'),
      border: InputBorder.none,
      errorStyle: TextStyle(color: Colors.grey[700],fontSize: 16),
      contentPadding: EdgeInsets.all(8),
      prefixIcon: IconButton(
        icon: Icon(isUnCover ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,size: 20,color: container,),
        onPressed: (){
          setState(() {
            isUnCover = !isUnCover;
          });
        },
      ),
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
