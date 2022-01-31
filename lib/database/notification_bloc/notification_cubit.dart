import 'package:alena_admin/database/admins/admins_repository.dart';
import 'package:alena_admin/database/notification_bloc/notification_state.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationCubit extends Cubit<NotificationState>{
  final AdminsRepository userRepository;

  NotificationCubit({this.userRepository}) : super(NotificationInitial());

  List<NotificationModel> _list;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadAdminNotificationData()async{
    try {
        _list = await userRepository.getAllAdminNotification(_auth.currentUser.uid);
        if(_list != null) {
          emit(NotificationSuccessful(_list));
        }else{
          emit(NotificationFailure());
        }
    }catch(e){
      print(e.toString());
      emit(NotificationFailure());
    }
 }

}