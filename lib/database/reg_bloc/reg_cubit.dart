import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/models/vendor.dart';
import 'reg_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegCubit extends Cubit<RegState>{
  final AdminsRepository userRepository;

  RegCubit({this.userRepository}) : super(RegInitial());

  Vendor _user;
  User fireUser ;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadUserData()async{
    try {
      emit(RegLoading());
        fireUser = await userRepository.getCurrentUser();
        _user = await userRepository.getUserById(fireUser.uid);
        if(_user != null) {
          emit(RegUserLoaded(_user));
        }else{
          emit(RegLoadError());
        }
    }catch(e){
      print(e.toString());
      emit(RegLoadError());
    }
 }

  // sign up with email
  Future<bool> signUpUserWithEmailPass(String email, String pass) async {
    try {
      emit(RegLoading());
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      print("REPO : ${authResult.user.email}");
      bool newUser = await userRepository.authenticateUser(authResult.user);
      if(newUser == true){
        Vendor appUser = Vendor(id: authResult.user.uid,username: email,locations: [],contacts: [],devices: [],regions: []);
        await userRepository.saveVendorToDb(appUser.toMap(), authResult.user.uid);
        loadUserData();
        return true;
      } else {
        emit(RegLoadError());
        return false;
      }
    }  catch (e) {
      emit(RegLoadError());
      print(e.toString());
      return false;
    }
  }

}