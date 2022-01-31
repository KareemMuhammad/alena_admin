import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  static const String ORDER_ID = "orderId";
  static const String ORDER_VENDOR_ID = "orderVendorId";
  static const String ORDER_PHONE = "orderPhone";
  static const String ORDER_USER = "user";
  static const String ORDER_PRODUCT = "product";
  static const String ORDER_DATE = "orderDate";
  static const String ORDER_STEP = "orderStep";

  String _orderId;
  String _date;
  String _phone;
  String _vendorId;
  int _orderStep;
  AppUser _user;
  Product _product;

  OrderModel(this._orderId, this._date, this._user, this._product,this._phone,this._vendorId,this._orderStep);

  Product get getProduct => _product;

  set setProduct(Product value) {
    _product = value;
  }

  String get getVendorId => _vendorId;

  set setVendorId(String value) {
    _vendorId = value;
  }

  int get getOrderStep => _orderStep;

  set setOrderStep(int value) {
    _orderStep = value;
  }

  String get getPhone => _phone;

  set setPhone(String value) {
    _phone = value;
  }

  AppUser get getUser => _user;

  set setUser(AppUser value) {
    _user = value;
  }

  String get getDate => _date;

  set setDate(String value) {
    _date = value;
  }

  String get getOrderId => _orderId;

  set setOrderId(String value) {
    _orderId = value;
  }

  Map<String,dynamic> toMap()=>{
    ORDER_ID : getOrderId ?? '',
    ORDER_DATE : getDate ?? '',
    ORDER_PHONE : getPhone ?? '',
    ORDER_VENDOR_ID : getVendorId ?? '',
    ORDER_PRODUCT : getProduct.toMap() ?? {},
    ORDER_USER : getUser.toMap() ?? {},
    ORDER_STEP : getOrderStep ?? 0,
  };

  OrderModel.fromSnapshot(DocumentSnapshot doc){
    setOrderId = (doc.data() as Map)[ORDER_ID] ?? '';
    setDate = (doc.data() as Map)[ORDER_DATE] ?? '';
    setPhone = (doc.data() as Map)[ORDER_PHONE] ?? '';
    setVendorId = (doc.data() as Map)[ORDER_VENDOR_ID] ?? '';
    setOrderStep = (doc.data() as Map)[ORDER_STEP] ?? 0;
    setProduct = Product.fromMap((doc.data() as Map)[ORDER_PRODUCT]) ?? {};
    setUser = AppUser.fromMap((doc.data() as Map)[ORDER_USER]) ?? {};
  }
}