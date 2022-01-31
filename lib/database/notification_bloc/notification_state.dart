import 'package:alena_admin/models/notification_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState{}

class NotificationFailure extends NotificationState{}

class NotificationSuccessful extends NotificationState{
 final List<NotificationModel> notificationModel;

 NotificationSuccessful(this.notificationModel);
}