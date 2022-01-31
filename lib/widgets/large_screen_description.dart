import 'package:alena_admin/utils/shared.dart';
import 'package:flutter/material.dart';

class LargeScreenImage extends StatelessWidget {
  final String text;
  final String title;

  const LargeScreenImage({Key key, this.text, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function())setState)
      {
        return WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Material(
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                color: white,
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close, color: black,)),

                            Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: button,
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(title,style: TextStyle(color: white,fontSize: 20),textAlign: TextAlign.end,),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(text,style: TextStyle(color: black,fontSize: 18),textAlign: TextAlign.end,)),
                    ),
                  ],
                )
              ),
            ),
          ),
        );
      },
    );
  }
}
