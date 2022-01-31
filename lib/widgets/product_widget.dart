import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/screens/manage/edit_product.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'delete_product_dialog.dart';
import 'large_screen_description.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  final ProductCubit productCubit;

  const ProductWidget({Key key, this.product, this.productCubit}) : super(key: key);
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.screenHeight * 0.3,
          width: SizeConfig.screenWidth,
          child: Swiper(
            loop: false,
            itemCount: widget.product.images.length,
            pagination: new SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: new DotSwiperPaginationBuilder(
                  color: Colors.grey[500], activeColor: button),
            ),
            itemBuilder: (BuildContext context,int imageIndex){
              return CachedNetworkImage(
                imageBuilder: (context, imageProvider) =>
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: imageProvider,
                        ),
                      ),
                    ),
                width: double.maxFinite,
                height: double.maxFinite,
                imageUrl: widget.product.images[imageIndex],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Image.asset('assets/image-not-found.png'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
          ),
        ),
        const SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Text('${widget.product.date.split(' ')[0]}', style: TextStyle(color: Colors.grey[700],fontSize: 17),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Text('${widget.product.productName}', style: TextStyle(color: Colors.black,fontSize: 19),),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${widget.product.deviceName}',
            style: TextStyle(color: Colors.grey[800], fontSize: 21,fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,maxLines: 1,),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15,5,15,0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Text('${widget.product.description}',
                style: TextStyle(color: Colors.grey[800],fontSize: 17),maxLines: 2,
                overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.arrow_back, size: 18,),
              onPressed: () async {
                await showDialog(context: context, builder: (_) {
                  return LargeScreenImage(
                    text: widget.product.description,
                    title: widget.product.productName,);
                });
              },
              label: Text('المزيد', style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: ''),),),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Text('${widget.product.price.toInt()}',
                style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(button),elevation: MaterialStateProperty.all(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('تعديل',style: TextStyle(color: white,fontSize: 18),),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: widget.product,)));
                },
              ),
              const SizedBox(width: 15,),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(button),elevation: MaterialStateProperty.all(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('حذف',style: TextStyle(color: white,fontSize: 18),),
                ),
                onPressed: (){
                  showDialog(context: context, builder: (_){
                    return Dialog(
                      backgroundColor: white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: DeleteProdDialog(productCubit: widget.productCubit,
                        productId: widget.product.id,imagesUrls: widget.product.images,),
                    );
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
