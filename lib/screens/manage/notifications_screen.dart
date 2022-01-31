import 'package:alena_admin/database/notification_bloc/notification_cubit.dart';
import 'package:alena_admin/database/notification_bloc/notification_state.dart';
import 'package:alena_admin/screens/wrapper_screen.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  final bool isAppTerminated;

  const NotificationsScreen({Key key, this.isAppTerminated}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationCubit>(context).loadAdminNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              if(widget.isAppTerminated) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => WrapperScreen()));
              }else{
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.close, color: black,)),
        title: Text('الاشعارات',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: BlocBuilder<NotificationCubit,NotificationState>(
        builder: (BuildContext context, state) {
          if(state is NotificationSuccessful){
            return state.notificationModel.isEmpty?
            Center(child: Text('لا يوجد اشعارات حاليا', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),)
                : Column(
                 children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.notificationModel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              color: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: ListTile(
                                  trailing: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage('assets/logo.png'),
                                  ),
                                  leading: Text('${getDiaryTime(state.notificationModel[index].time)}',style: TextStyle(color: Colors.black54,fontSize: 15),),
                                  title: Text(state.notificationModel[index].title, style: TextStyle(
                                      fontSize: 18,
                                      color: black,
                                      fontFamily: 'AA-GALAXY')
                                    , textAlign: TextAlign.end,),
                                  subtitle: Text(state.notificationModel[index].body, style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black54,
                                      fontFamily: 'AA-GALAXY')
                                    , textAlign: TextAlign.end,),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),

                ],
            );
          }else if(state is NotificationInitial){
            return spinKit;
          }else if(state is NotificationFailure){
            return Center(
              child: Text('حدث خطأ فى جلب البيانات',style: TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }

  String getDiaryTime(String date){
    DateTime time = DateTime.parse(date);
    String timeAgo = timeago.format(time);
    return timeAgo;
  }
}
