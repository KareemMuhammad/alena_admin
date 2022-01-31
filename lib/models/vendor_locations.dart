import 'package:cloud_firestore/cloud_firestore.dart';

class VendorLocations{

  static const String LOCATION_NAME = 'locationName';
  static const String LOCATION_ADDRESS = 'address';
  static const String GEO_POINT = 'geoPoint';

  String locationName;
  String address;
  GeoPoint geoPoint;

  VendorLocations({this.locationName, this.geoPoint,this.address});

  VendorLocations.fromMap(Map<String,dynamic> map){
    locationName = map[LOCATION_NAME] ?? '';
    geoPoint = map[GEO_POINT] ?? GeoPoint(0, 0);
    address = map[LOCATION_ADDRESS] ?? '';
  }

  Map<String,dynamic> toMap()=>{
    LOCATION_NAME : locationName ?? '',
    GEO_POINT : geoPoint ?? GeoPoint(0, 0),
    LOCATION_ADDRESS : address ?? '',
  };
}