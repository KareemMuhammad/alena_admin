import 'dart:async';
import 'dart:io';
import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:alena_admin/screens/manage/notifications_screen.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationServices{
  final FirebaseAuth auth;
  final FirebaseMessaging messaging;
  final AdminsRepository adminsRepository;

  const PushNotificationServices({this.adminsRepository, this.auth, this.messaging,});

  Future initiate() async{
    if(auth.currentUser != null) {
      if(Platform.isIOS){
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          print('User granted permission');
        } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
          print('User granted provisional permission');
        } else {
          print('User declined or has not accepted permission');
        }
      }
          final String token = await FirebaseMessaging.instance.getToken();
          adminsRepository.updateUserToken(token,auth.currentUser.uid);

      messaging.getInitialMessage().then((message) {
        if(message != null) {
          navigatorKey.currentState.push(MaterialPageRoute(
              builder: (_) => NotificationsScreen(isAppTerminated: true)));
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('On message listen!');
        RemoteNotification notification = message.notification;
        if (notification != null) {
          // Utils.showNotification(message.data["id"], NotificationModel.fromMap(message.data),diaryProvider,userProvider);
          NotificationModel model = NotificationModel(title: message.data[NotificationModel.TITLE],body: message.data[NotificationModel.BODY],
              icon: message.data[NotificationModel.ICON],time: message.data[NotificationModel.TIME],id: message.data[NotificationModel.NOT_ID],
              vendorId: message.data[NotificationModel.VENDOR_ID],route: message.data[NotificationModel.ROUTE],productId: message.data[NotificationModel.PRODUCT_ID]);
          adminsRepository.saveNotificationToDb(model.toMap(), model.id);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        navigatorKey.currentState.push(MaterialPageRoute(builder: (_)
        => NotificationsScreen(isAppTerminated: true)));
      });
    }
  }

}