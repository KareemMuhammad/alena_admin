import 'package:alena_admin/utils/shared.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String image;
  final String text;

  const CustomAlertDialog({Key key, this.image, this.text}) : super(key: key);
  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.4,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset('${widget.image}',width: 130,height: 150,),
          Text('${widget.text}',style: TextStyle(color: black,fontSize: 20,fontFamily: 'AA-GALAXY'),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(button),elevation: MaterialStateProperty.all(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('خروج',style: TextStyle(color: white,fontSize: 18),),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
