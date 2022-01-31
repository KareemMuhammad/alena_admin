import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/database/category_cubit/category_cubit.dart';
import 'package:alena_admin/database/notification_bloc/notification_cubit.dart';
import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/database/products/product_repository.dart';
import 'package:alena_admin/database/reg_bloc/reg_cubit.dart';
import 'package:alena_admin/screens/wrapper_screen.dart';
import 'package:alena_admin/services/remote_config.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/admins/admins_bloc.dart';
import 'database/order/order_cubit.dart';
import 'database/order/order_repository.dart';
import 'models/notification_model.dart';

final _auth = FirebaseAuth.instance;
AdminsRepository _adminsRepository = AdminsRepository();
RemoteConfigService remoteConfigService;
SharedPreferences sharedPref;
bool prefValue;

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if(_auth.currentUser != null) {
    NotificationModel model = NotificationModel(title: message.data[NotificationModel.TITLE],body: message.data[NotificationModel.BODY],
        icon: message.data[NotificationModel.ICON],time: message.data[NotificationModel.TIME],id: message.data[NotificationModel.NOT_ID],
        vendorId: message.data[NotificationModel.VENDOR_ID],route: message.data[NotificationModel.ROUTE],productId: message.data[NotificationModel.PRODUCT_ID]);
    await _adminsRepository.saveNotificationToDb(model.toMap(), model.id);
    print("Handling a background message: ${message.messageId}");
  }
}

Future initializeRemoteConfig() async {
  remoteConfigService = await RemoteConfigService.getInstance();
  await remoteConfigService.initialize();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  prefValue = sharedPref.getBool(Utils.SHARED_KEY);
  await Firebase.initializeApp();
  await initializeRemoteConfig();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(userRepository: AdminsRepository())..authUser(),
        ),
        BlocProvider(
          create: (context) => AdminsCubit(adminsRepository: AdminsRepository()),
        ),
        BlocProvider(
          create: (context) => ProductCubit(productRepo: ProductRepository()),
        ),
        BlocProvider(
          create: (context) => OrderCubit(orderRepository: OrderRepository()),
        ),
        BlocProvider(
          create: (context) => RegCubit(userRepository: AdminsRepository()),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(userRepository: AdminsRepository()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red[700],
          accentColor: Colors.red,
          fontFamily: 'Tajawal-Medium',
        ),
        home: WrapperScreen(),
      ),
    );
  }
}


