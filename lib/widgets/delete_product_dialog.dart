import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class DeleteProdDialog extends StatelessWidget {
  final ProductCubit productCubit;
  final String productId;
  final List<dynamic> imagesUrls;

  const DeleteProdDialog({Key key, this.productCubit, this.productId, this.imagesUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
          children: [
           const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('هل تريد حذف هذا المنتج؟',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: button,fontFamily: 'AA-GALAXY')
                ,textAlign: TextAlign.center,),
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
                 await manageDelete();
                 Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('تأكيد',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,
                      fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Future manageDelete() async{
    for(String url in imagesUrls){
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
    productCubit.deleteProductById(productId);
  }
}
