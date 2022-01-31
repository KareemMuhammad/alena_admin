import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../utils/shared.dart';

class DeniedProdDialog extends StatefulWidget {
  final ProductCubit productCubit;
  final Product product;

  const DeniedProdDialog({Key key, this.productCubit, this.product}) : super(key: key);

  @override
  _DeniedProdDialogState createState() => _DeniedProdDialogState();
}

class _DeniedProdDialogState extends State<DeniedProdDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.4,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('هل تريد رفض هذا المنتج؟',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'وضح السبب',
                    hintTextDirection: TextDirection.rtl,
                  ),
                  validator: (value) {
                    return value.isEmpty ? 'لازم تكتب سبب الرفض' : null;
                  }
              ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RaisedButton(
                color: button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                onPressed: () async{
                  if(_formKey.currentState.validate()) {
                    await manageDelete();
                    await BlocProvider.of<AdminsCubit>(context).updateAdminWaitNo(-1,widget.product.vendorId);
                    await BlocProvider.of<AdminsCubit>(context).updateAdminDevicesList(0, widget.product.vendorId, widget.product.productName);
                    NotificationModel model = NotificationModel(id: Uuid().v1(),title: 'تم رفض منتجك',
                        body: widget.product.productName, icon: Utils.APP_ICON_URL,time: Utils.currentDate(),
                        vendorId: widget.product.vendorId, productId: widget.product.id,route: '');
                    await Utils.sendPushMessage(model, widget.product.vendor.token);
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('تأكيد',style: TextStyle(letterSpacing: 1,fontSize: 21,color: white,
                      fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future manageDelete() async{
    for(String url in widget.product.images){
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
    widget.productCubit.removeWaitingById(widget.product.id);
  }
}