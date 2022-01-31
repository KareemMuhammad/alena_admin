import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/screens/manage/edit_info.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/shared.dart';

class ProfileScreen extends StatefulWidget {
  final Vendor appAdmin;

  const ProfileScreen({Key key, this.appAdmin}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close, color: black,)),
        title: Text('الملف الشخصى',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: BlocBuilder<AdminsCubit,AdminState>(
        builder: (BuildContext context, state) {
          if(state is AdminInitial){
           return SingleChildScrollView(
             child: Column(
                children: [
                  const SizedBox(height: 40,),
                  _customWidget('اسم التاجر', widget.appAdmin.brand ?? '',0,widget.appAdmin,context),
                  _customWidget('المدينة', widget.appAdmin.city ?? '',1,widget.appAdmin,context),
                  _customWidget('جهات الاتصال', widget.appAdmin.contacts.isEmpty ? '' : widget.appAdmin.contacts.first ,3,widget.appAdmin,context),
                  _customWidget('الفروع', widget.appAdmin.locations.isEmpty ? '' : widget.appAdmin.locations.first.address ,4,widget.appAdmin,context),
                  _customWidget('الشعار', widget.appAdmin.logo ?? '',2,widget.appAdmin,context),
                  Container(
                    margin: const EdgeInsets.all(13.0),
                    padding: const EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: button,
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        BlocProvider.of<AuthCubit>(context).signOut();
                        BlocProvider.of<AdminsCubit>(context).emit(AdminInitial());
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,color: white,size: 20,),
                          const SizedBox(width: 5,),
                          Text('تسجيل خروج',style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
           );
          }
          if(state is AdminLoaded){
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  _customWidget('اسم التاجر', state.appAdmin.brand ?? '',0,state.appAdmin,context),
                  _customWidget('المدينة', state.appAdmin.city ?? '',1,state.appAdmin,context),
                  _customWidget('جهات الاتصال', state.appAdmin.contacts.isEmpty ? '' :  state.appAdmin.contacts.first,3,state.appAdmin,context),
                  _customWidget('الفروع', state.appAdmin.locations.isEmpty ? '' : state.appAdmin.locations.first.address ,4,state.appAdmin,context),
                  _customWidget('الشعار', state.appAdmin.logo ?? '',2,state.appAdmin,context),

              Container(
                margin: const EdgeInsets.all(13.0),
                padding: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: button,
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    BlocProvider.of<AuthCubit>(context).signOut();
                    BlocProvider.of<AdminsCubit>(context).emit(AdminInitial());
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout,color: white,size: 20,),
                      const SizedBox(width: 5,),
                      Text('تسجيل خروج',style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
                    ],
                  ),
                ),
              ),
                ],
              ),
            );
          }else if(state is AdminLoading){
            return spinKit;
          }else if(state is AdminLoadError){
            return Center(
              child: Text('حدث خطأ فى جلب البيانات',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }

  Widget _customWidget(String title,String info,int load,Vendor appUser,BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => EditInfoScreen(load: load,title: title,appUser: appUser,)));
      },
      child: Container(
        margin: const EdgeInsets.all(13.0),
        padding: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: button,
        ),
        child: Row(
            children: [
              const Icon(Icons.arrow_back_ios,color: white,size: 20,),
              const SizedBox(width: 10,),
              load == 2?
              CircleAvatar(
                backgroundColor: white,
                radius: 30,
                backgroundImage: info.isNotEmpty? CachedNetworkImageProvider(info) : AssetImage('assets/image-not-found.png'),
              )
                  : Expanded(child: Text(info,style: TextStyle(color: white,fontSize: 17,),
                maxLines: 1,overflow: TextOverflow.ellipsis,)),
              const Spacer(),
              Text(title,style: TextStyle(color: white,fontSize: 18,fontFamily: 'AA-GALAXY'),)
            ],
          ),
      ),
    );
  }
}
