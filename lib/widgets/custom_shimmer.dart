import 'package:alena_admin/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const MyShimmer.rectangular({Key key, this.width = double.infinity, this.height, this.shapeBorder = const RoundedRectangleBorder()}) : super(key: key);

  const MyShimmer.circular({Key key, this.width, this.height, this.shapeBorder = const CircleBorder()}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: white,
            shape: shapeBorder,
          ),
        ),
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[100]);
  }
}
