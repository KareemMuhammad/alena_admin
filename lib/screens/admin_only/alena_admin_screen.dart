import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/database/products/product_state.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/denied_product_dialog.dart';
import 'package:alena_admin/widgets/large_screen_description.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:uuid/uuid.dart';

class AlenaAdminScreen extends StatefulWidget {

  @override
  _AlenaAdminScreenState createState() => _AlenaAdminScreenState();
}

class _AlenaAdminScreenState extends State<AlenaAdminScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductCubit>(context).loadWaitingProducts();
  }

  @override
  Widget build(BuildContext context) {
    final AdminsCubit adminsCubit = BlocProvider.of<AdminsCubit>(context);
    final ProductCubit productCubit = BlocProvider.of<ProductCubit>(context);
    return Scaffold(
      appBar: customAppBar(context),
      body: BlocConsumer<ProductCubit,ProductState>(
        listener: (ctx,state){
          if(state is ProductDeleted){
           productCubit.loadWaitingProducts();
          }
        },
        builder: (BuildContext context, state) {
          if(state is ProductInitial){
            return const SizedBox();
          }else if(state is ProductLoading){
            return spinKit;
          } else if(state is ProductLoaded) {
            return state.products.isEmpty?
            Center(child: Text('لا يوجد طلبات حاليا', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),)
                :ListView.builder(
                 itemCount: state.products.length,
                 itemBuilder: (BuildContext context, int index) {
                 return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 4,
                    color: white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * 0.4,
                            width: SizeConfig.screenWidth,
                            child: Swiper(
                              loop: false,
                              itemCount: state.products[index].images.length,
                              pagination: new SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: new DotSwiperPaginationBuilder(color: Colors.grey[500], activeColor: button),
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
                                  imageUrl: state.products[index].images[imageIndex],
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
                                child: Text('${state.products[index].date.split(' ')[0]}', style: TextStyle(color: Colors.grey[700],fontSize: 17),),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                child: Text('${state.products[index].vendor.brand}', style: TextStyle(color: Colors.black,fontSize: 19),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${state.products[index].productName} - ${state.products[index].category}',
                              style: TextStyle(color: Colors.grey[800], fontSize: 19,fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,maxLines: 1,),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,5,15,0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: Text('${state.products[index].description}',
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
                                      text: state.products[index].description,
                                      title: state.products[index].productName,);
                                  });
                                },
                                label: Text('المزيد', style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: ''),),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                                child: Text('${state.products[index].price}',
                                  style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green[800],
                                  radius: 28,
                                  child: IconButton(
                                      onPressed: ()async{
                                        await uploadProduct(productCubit,state.products[index]);
                                        await adminsCubit.updateAdminWaitNo(-1,state.products[index].vendorId);
                                        await adminsCubit.updateAdminProdNo(1,state.products[index].vendorId);
                                        await adminsCubit.updateAdminDevicesList(1, state.products[index].vendorId, state.products[index].productName);
                                        NotificationModel model = NotificationModel(id: Uuid().v1(),title: 'تم قبول منتجك',
                                            body: state.products[index].deviceName, icon: Utils.APP_ICON_URL,time: Utils.currentDate(),
                                            vendorId: state.products[index].vendorId, productId: state.products[index].id,route: '');
                                        await Utils.sendPushMessage(model, state.products[index].vendor.token);
                                        productCubit.removeWaitingById(state.products[index].id);
                                      },
                                      icon: const Icon(Icons.done),
                                      iconSize: 28,
                                      color: white,
                                  ),
                                ),
                                const SizedBox(width: 15,),
                                CircleAvatar(
                                  backgroundColor: button,
                                  radius: 28,
                                  child: IconButton(
                                    onPressed: (){
                                      showDialog(context: context, builder: (_){
                                        return Dialog(
                                          backgroundColor: white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                          child: DeniedProdDialog(productCubit: productCubit, product: state.products[index],),
                                        );
                                      });
                                    },
                                    icon: const Icon(Icons.clear),
                                    iconSize: 28,
                                    color: white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else if(state is ProductLoadError){
            return Center(child: Text('حدث خطأ فى جلب البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 23, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else if(state is ProductDeleteError){
            return Center(child: Text('حدث خطأ فى حذف البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 23, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else if(state is ProductNotUpdated){
            return Center(child: Text('حدث خطأ فى تعديل البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 23, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else{
            return Container();
          }
        },
      ),
    );
  }

  Future uploadProduct(ProductCubit productCubit,Product waitProduct) async{
    Product product = Product(id: waitProduct.id,images: waitProduct.images,price: waitProduct.price, productName: waitProduct.productName,
        description: waitProduct.description, vendor: waitProduct.vendor,category: waitProduct.category,city: waitProduct.city,
        vendorId: waitProduct.vendorId,date: waitProduct.date,geoPoint: waitProduct.geoPoint,status: true,deviceName: waitProduct.deviceName);
    await productCubit.addNewProduct(product, waitProduct.id);
  }
}
