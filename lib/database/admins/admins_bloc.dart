import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/models/vendor_locations.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminsCubit extends Cubit<AdminState>{

  final AdminsRepository adminsRepository;

  AdminsCubit({this.adminsRepository}) : super(AdminInitial());

  Vendor _user;
  User _fireUser;
  List<dynamic> countries = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
      emit(AdminLoading());
      _fireUser = await adminsRepository.getCurrentUser();
      _user = await adminsRepository.getUserById(_fireUser.uid);
      print(_user.username);
      if(_user != null) {
        emit(AdminLoaded(_user));
      }else{
        emit(AdminLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(AdminLoadError());
    }
  }

  Future resetPassword(String email)async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      emit(VendorPassReset());
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateAdminInfo(String name,String key)async{
    try {
      await adminsRepository.updateInfo(name, _auth.currentUser.uid,key);
      loadUserData();
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateCurrentVendor(Vendor vendor)async{
    try {
      await adminsRepository.updateCurrentUser(vendor.toMap(), _auth.currentUser.uid,);
      loadUserData();
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateAdminProdNo(int no,String vendorId)async{
    try {
      await adminsRepository.updateProductsNumber(vendorId,no);
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateAdminWaitNo(int no,String vendorId)async{
    try {
      await adminsRepository.updateWaitingNumber(vendorId,no);
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateAdminDevicesList(int no,String vendorId,String device)async{
    try {
      if(no == 1) {
        await adminsRepository.updateDevices(vendorId, device);
      }
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateContacts(List<dynamic> contacts)async{
    try {
      await adminsRepository.updateAdminContacts(contacts, _auth.currentUser.uid);
      loadUserData();
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateRegions(String region)async{
    try {
      await adminsRepository.updateAdminRegions(region, _auth.currentUser.uid);
      loadUserData();
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future updateLocations(List<VendorLocations> loc)async{
    try {
      await adminsRepository.freeVendorLocations(_auth.currentUser.uid);
      for(VendorLocations locations in  loc) {
        await adminsRepository.addLocationToVendor(locations.toMap(), _auth.currentUser.uid);
      }
      loadUserData();
    }catch(e){
      emit(AdminLoadError());
      print(e.toString());
    }
  }

  Future<bool> signInEmailAndPassword(String email, String password) async {
    try {
      emit(AdminLoading());
      var authresult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool newUser = await adminsRepository.authenticateUser(authresult.user);
      if(newUser){
        emit(AdminLoadError());
      }else{
        if(password == ADMIN_PASS){
          emit(AdminAlenaIn());
        }else {
          loadUserData();
        }
      }
      return newUser;
    } catch (e) {
      emit(AdminLoadError());
      print(e.toString());
      return true;
    }
  }

  Future<bool> signInAdmin(String email, String password) async {
    try {
      emit(AdminLoading());
      var authresult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(authresult == null){
        emit(AdminLoadError());
      }else{
        emit(AdminAlenaIn());
      }
      return true;
    } catch (e) {
      emit(AdminLoadError());
      print(e.toString());
      return false;
    }
  }

}