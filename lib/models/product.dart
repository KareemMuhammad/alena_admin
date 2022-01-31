import 'package:alena_admin/models/vendor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  static const String ID = "id";
  static const String PRODUCT_NAME = "name";
  static const String DEVICE_NAME = "deviceName";
  static const String CATEGORY = "category";
  static const String PRICE = "price";
  static const String IMAGES = "images";
  static const String DESC = "description";
  static const String CITY = "city";
  static const String VENDOR = "vendor";
  static const String VENDOR_ID = "vendorId";
  static const String DATE = "date";
  static const String GEO_POINT = "geoPoint";
  static const String STATUS = "status";

  String id;
  String productName;
  String deviceName;
  String category;
  double price;
  List<dynamic> images;
  String description;
  String city;
  String date;
  String vendorId;
  bool status;
  GeoPoint geoPoint;
  Vendor vendor;

  Product({this.id, this.productName, this.category, this.price, this.images,
      this.description,this.vendor,this.city,this.date,this.vendorId,this.geoPoint,this.status,this.deviceName});

  Map<String,dynamic> toMap()=>{
    ID : id ?? '',
    PRODUCT_NAME : productName ?? '',
    DEVICE_NAME : deviceName ?? '',
    CATEGORY : category ?? '',
    PRICE : price.toString() ?? '',
    IMAGES : images ?? [],
    DESC : description ?? '',
    DATE : date ?? '',
    VENDOR_ID : vendorId ?? '',
    CITY : city ?? '',
    VENDOR : {Vendor.CONTACTS : vendor.contacts, Vendor.BRAND : vendor.brand,Vendor.TOKEN: vendor.token,Vendor.LOGO: vendor.logo} ?? {},
    STATUS : status ?? false,
    GEO_POINT : geoPoint ?? GeoPoint(0, 0),
  };

  Product.fromSnapshot(DocumentSnapshot doc){
    id = (doc.data() as Map)[ID] ?? '';
    productName = (doc.data() as Map)[PRODUCT_NAME] ?? '';
    deviceName = (doc.data() as Map)[DEVICE_NAME] ?? '';
    category = (doc.data() as Map)[CATEGORY] ?? '';
    price = double.parse((doc.data() as Map)[PRICE]) ?? 0;
    images = (doc.data() as Map)[IMAGES] ?? [];
    description = (doc.data() as Map)[DESC] ?? '';
    city = (doc.data() as Map)[CITY] ?? '';
    vendorId = (doc.data() as Map)[VENDOR_ID] ?? '';
    date = (doc.data() as Map)[DATE] ?? '';
    vendor = Vendor.fromMap((doc.data() as Map)[VENDOR] ?? {}) ?? {};
    geoPoint = (doc.data() as Map)[GEO_POINT] ?? GeoPoint(0, 0);
    status = (doc.data() as Map)[STATUS] ?? false;
  }

  Product.fromMap(Map<String,dynamic> map){
    id = map[ID] ?? '';
    productName = map[PRODUCT_NAME] ?? [];
    deviceName = map[DEVICE_NAME] ?? '';
    category = map[CATEGORY] ?? '';
    price = double.parse(map[PRICE]) ?? 0;
    images = map[IMAGES] ?? [];
    description = map[DESC] ?? '';
    city = map[CITY] ?? '';
    vendorId = map[VENDOR_ID] ?? '';
    vendor = Vendor.fromMap(map[VENDOR]) ?? {};
    geoPoint = map[GEO_POINT] ?? GeoPoint(0, 0);
    date = map[DATE] ?? '';
  }
}