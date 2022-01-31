import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/database/notification_services.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/screens/manage/my_products_screen.dart';
import 'package:alena_admin/screens/manage/notifications_screen.dart';
import 'package:alena_admin/screens/manage/orders_screen.dart';
import 'package:alena_admin/screens/manage/profile_screen.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/categories_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage/add_product.dart';
import 'package:flutter/material.dart';

enum Page { dashboard, manage }

class DashboardScreen extends StatefulWidget {
  final Vendor alenaAdmin;

  const DashboardScreen({Key key, this.alenaAdmin}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  PushNotificationServices fcm = PushNotificationServices(auth: FirebaseAuth.instance,
      adminsRepository: AdminsRepository(),messaging: FirebaseMessaging.instance);

  @override
  void initState() {
    super.initState();
    fcm.initiate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard ? active : notActive,
                      ),
                      label: Text('لوحة التحكم',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 16),))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color: _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('الإدارة',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 16),))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return BlocBuilder<AdminsCubit,AdminState>(
            builder: (ctx,state){
            if(state is AdminLoaded){
              return Column(
                children: <Widget>[
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.track_changes),
                                    label: Text("منتجاتى",style: TextStyle(fontSize: 20,color: black),)),
                                subtitle: Text(
                                  '${state.appAdmin.productNo}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.tag_faces),
                                    label: Text("مبيعاتى",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.shopping_cart),
                                    label: Text("الطلبات",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text('0', textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.all_inclusive),
                                    label: Text("الانتظار",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text('${state.appAdmin.waitingNo}', textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else if(state is AdminInitial){
              return Column(
                children: <Widget>[
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.track_changes),
                                    label: Text("منتجاتى",style: TextStyle(fontSize: 20,color: black),)),
                                subtitle: Text(
                                  '${widget.alenaAdmin.productNo}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.tag_faces),
                                    label: Text("مبيعاتى",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.shopping_cart),
                                    label: Text("الطلبات",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text('0', textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: ListTile(
                                title: FlatButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.all_inclusive),
                                    label: Text("الإنتظار",style: TextStyle(fontSize: 20,color: black))),
                                subtitle: Text('${widget.alenaAdmin.waitingNo}', textAlign: TextAlign.center,
                                  style: TextStyle(color: active, fontSize: 40.0),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else if(state is AdminLoading){
              return spinKit;
            }else if(state is AdminLoadError){
              return Center(
                child: Text('حدث خطأ فى جلب البيانات',style: TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'AA-GALAXY')
                  ,textAlign: TextAlign.center,),
              );
            }else{
              return Container();
            }
        });
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const Icon(Icons.add),
                title: Text("إضافة منتج",style: TextStyle(fontSize: 20),),
                onTap: () {
                 showDialog(context: context, builder: (_){
                    return Dialog(
                        backgroundColor: white,
                        child: Wrap(
                          children: [
                            CategoriesDialog(),
                          ],
                        ));
                  },barrierDismissible: false).then((value) {
                   if(value != null) {
                     Navigator.push(context, MaterialPageRoute(builder: (_) =>
                         AddProduct(alenaAdmin: widget.alenaAdmin,category: value,)));
                   }
                 });
                },
              ),
            ),
            const Divider(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const Icon(Icons.change_history),
                title: Text("قائمة منتجاتى",style: TextStyle(fontSize: 20),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MyProductsScreen()));
                },
              ),
            ),
            const Divider(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text("إدارة الملف الشخصى",style: TextStyle(fontSize: 20),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(appAdmin: widget.alenaAdmin,)));
                },
              ),
            ),
            const Divider(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text("إدارة الطلبات",style: TextStyle(fontSize: 20),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrdersScreen(vendor: widget.alenaAdmin,)));
                },
              ),
            ),
            const Divider(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const  Icon(Icons.notifications),
                title: Text("الإشعارات",style: TextStyle(fontSize: 20),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(isAppTerminated: false,)));
                },
              ),
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }

}
