import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  static const String TITLE = "title";
  static const String NOT_ID = "id";
  static const String BODY = "body";
  static const String ICON = "icon";
  static const String ROUTE = "route";
  static const String VENDOR_ID = "vendorId";
  static const String TIME = "time";
  static const String PRODUCT_ID = "productId";

  String title;
  String body;
  String icon;
  String route;
  String vendorId;
  String time;
  String productId;
  String id;

  NotificationModel({this.title, this.body,this.route,this.icon,this.time,this.vendorId,this.productId,this.id});

  NotificationModel.fromMap(Map<String,dynamic> notMap){
    title = notMap[TITLE] ?? '';
    body = notMap[BODY] ?? '';
    vendorId = notMap[VENDOR_ID] ?? '';
    icon = notMap[ICON] ?? '';
    route = notMap[ROUTE] ?? '';
    time = notMap[TIME] ?? '';
    productId = notMap[PRODUCT_ID] ?? '';
    id = notMap[NOT_ID] ?? '';
  }

  NotificationModel.fromSnapshot(DocumentSnapshot doc){
    title = (doc.data() as Map)[TITLE] ?? '';
    body = (doc.data() as Map)[BODY] ?? '';
    vendorId = (doc.data() as Map)[VENDOR_ID] ?? '';
    icon = (doc.data() as Map)[ICON] ?? '';
    route = (doc.data() as Map)[ROUTE] ?? '';
    time = (doc.data() as Map)[TIME] ?? [];
    productId = (doc.data() as Map)[PRODUCT_ID] ?? '';
    id = (doc.data() as Map)[NOT_ID] ?? '';
  }

  Map<String,dynamic> toMap()=>{
    TITLE : title ?? '',
    BODY : body ?? '',
    VENDOR_ID : vendorId ?? '',
    ICON : icon ?? '',
    ROUTE : route ?? '',
    TIME : time ?? '',
    PRODUCT_ID : productId ?? '',
    NOT_ID : id ?? ''
  };
}