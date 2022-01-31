import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: button,
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}
