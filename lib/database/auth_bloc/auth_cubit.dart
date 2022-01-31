import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/database/auth_bloc/auth_state.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState>{
  final AdminsRepository userRepository;

  AuthCubit({this.userRepository}) : super(AuthInitial());

  Vendor _user;
  User _fireUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
        _fireUser = await userRepository.getCurrentUser();
        _user = await userRepository.getUserById(_fireUser.uid);
        if(_user != null) {
          if(_user.brand.isEmpty){
            emit(AuthSetup(_user));
          }else {
            emit(AuthSuccessful(_user));
          }
        }else{
          emit(AuthFailure());
        }
    }catch(e){
      print(e.toString());
      emit(AuthFailure());
    }
 }

  Future authUser()async{
    try {
      _fireUser = await userRepository.getCurrentUser();
      if(_fireUser != null) {
        if(_fireUser.email != 'technical.outoftheboxegypt@gmail.com') {
          loadUserData();
        }else{
          emit(AuthAdminAlena());
        }
      }else{
        emit(AuthFailure());
      }
    }catch(e){
      print(e.toString());
      emit(AuthFailure());
    }
  }

  Future signOut()async{
    try{
      if(_auth.currentUser != null) {
        await _auth.signOut();
      }
      emit(AuthFailure());
    }catch(e){
      emit(AuthFailure());
      print(e.toString());
    }
  }

}