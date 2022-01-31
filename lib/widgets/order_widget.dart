import 'package:alena_admin/models/order.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderWidget({Key key, this.orderModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 2,
        color: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                color: Colors.grey[300],
              ),
              width: SizeConfig.screenWidth,
              height: 120,
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(textAlign: TextAlign.end,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: ' تم الطلب بتاريخ:',
                                    style: TextStyle(color: black,fontSize: 19,fontFamily: 'AA-GALAXY',)
                                ),
                                TextSpan(
                                    text: '${orderModel.getDate.split(' ')[0]}  ',
                                    style: TextStyle(color: Colors.grey[700],fontSize: 19,fontFamily: 'AA-GALAXY'
                                        ,decoration: TextDecoration.underline)
                                ),
                              ]),
                        ),
                        RichText(textAlign: TextAlign.end,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: ' اسم العميل:',
                                    style: TextStyle(color: black,fontSize: 19,fontFamily: 'AA-GALAXY')
                                ),
                                TextSpan(
                                    text: '${orderModel.getUser.name}  ',
                                    style: TextStyle(color: Colors.grey[700],fontSize: 19,fontFamily: 'AA-GALAXY'
                                        ,decoration: TextDecoration.underline)
                                ),
                              ]),
                        ),
                        RichText(textAlign: TextAlign.end,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text:  ' رقم العميل:',
                                    style: TextStyle(color: black,fontSize: 19,fontFamily: 'AA-GALAXY')
                                ),
                                TextSpan(
                                    text: '${orderModel.getPhone}  ',
                                    style: TextStyle(color: Colors.grey[700],fontSize: 19,fontFamily: 'AA-GALAXY'
                                        ,decoration: TextDecoration.underline)
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              tileColor: white,
              trailing: CachedNetworkImage(
                imageUrl: "${orderModel.getProduct.images.first}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Image.asset('assets/image-not-found.png'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              title: Text('${orderModel.getProduct.deviceName}',
                style: TextStyle(fontSize: 20,color: black)
                ,textAlign: TextAlign.end,),
              subtitle: Text('${orderModel.getProduct.price}',
                style: TextStyle(fontSize: 20,color: black)
                ,textAlign: TextAlign.end,),
            ),
            Material(
              color: button,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))),
              child: MaterialButton(
                minWidth: SizeConfig.screenWidth,
                onPressed: () async{

                },
                child: Text('تواصل مع العميل',style: TextStyle(fontSize: 20,color: white, fontFamily: 'AA-GALAXY'),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
