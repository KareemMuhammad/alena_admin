import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminsRepository{
 static const String ADMINS_COLLECTION = "Admins";
 static const String NOTIFICATIONS_COLLECTION = "Notifications";

 final _adminsCollection = FirebaseFirestore.instance.collection(AdminsRepository.ADMINS_COLLECTION);
 final _notificationsCollection = FirebaseFirestore.instance.collection(AdminsRepository.NOTIFICATIONS_COLLECTION);

 Future<Vendor> getUserById(String id){
  return _adminsCollection.doc(id).get().then((doc){
   return Vendor.fromSnapshot(doc);
  });
 }

 Future saveVendorToDb(Map<String,dynamic> userMap,String id)async{
  await _adminsCollection.doc(id).set(userMap);
 }

 Future<List<NotificationModel>> getAllAdminNotification(String id)async{
  QuerySnapshot snapshot = await _notificationsCollection.where(NotificationModel.VENDOR_ID, isEqualTo: id).orderBy(NotificationModel.TIME,descending: true).get()
      .catchError((e) {
   print(e.toString());
  });
  return snapshot.docs.map((doc) {
   return NotificationModel.fromSnapshot(doc);
  }).toList();
 }

 Future saveNotificationToDb(Map<String,dynamic> userMap,String id)async{
  await _notificationsCollection.doc(id).set(userMap);
 }

 Future<bool> authenticateUser(User user) async {
  QuerySnapshot result = await _adminsCollection
      .where(Vendor.USER_NAME, isEqualTo: user.email)
      .get();
  final List<DocumentSnapshot> docs = result.docs;
  print(docs.length);
  return docs.length == 0 || docs.isEmpty ? true : false;
 }

 Future<User> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
 }

 Future updateInfo(String brand,String id,String key)async{
  await _adminsCollection.doc(id).update({key : brand});
 }

 Future updateCurrentUser(Map<String,dynamic> map,String id)async{
  await _adminsCollection.doc(id).update(map);
 }

 Future updateUserToken(String token,String id)async{
  await  _adminsCollection.doc(id).update({Vendor.TOKEN : token });
 }

 Future updateAdminContacts(List<dynamic> brand,String id)async{
  await _adminsCollection.doc(id).update({Vendor.CONTACTS : brand });
 }

 Future updateAdminRegions(String region,String id)async{
  await _adminsCollection.doc(id).update({Vendor.REGIONS : FieldValue.arrayUnion([region]) });
 }

 Future addLocationToVendor(Map<String,dynamic> map,String id)async{
  await _adminsCollection.doc(id).update({Vendor.LOCATIONS: FieldValue.arrayUnion([map])});
 }

 Future freeVendorLocations(String id)async{
  await _adminsCollection.doc(id).update({Vendor.LOCATIONS: []});
 }

 Future updateProductsNumber(String id,int no)async{
  await _adminsCollection.doc(id).update({Vendor.PRODUCTS_NO: FieldValue.increment(no)});
 }

 Future updateWaitingNumber(String id, int no)async{
  await _adminsCollection.doc(id).update({Vendor.WAITING_NO: FieldValue.increment(no)});
 }

 Future updateDevices(String id,String device)async{
  await _adminsCollection.doc(id).update({Vendor.DEVICES: FieldValue.arrayUnion([device])});
 }

 Future removeDevices(String id,String device)async{
  await _adminsCollection.doc(id).update({Vendor.DEVICES: FieldValue.arrayRemove([device])});
 }

}