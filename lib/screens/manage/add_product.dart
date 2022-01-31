import 'dart:io';
import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/database/products/product_state.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/screens/manage/edit_info.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/alert_dialog_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  final Vendor alenaAdmin;
  final String category;

  const AddProduct({Key key, this.alenaAdmin, this.category}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 final TextEditingController nameController = TextEditingController();
 final TextEditingController priceController = TextEditingController();
 final TextEditingController descriptionController = TextEditingController();

  String _deviceName = '';
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> categories;
  String _brand = '';
  String _desc = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductCubit>(context).emit(ProductInitial());
    categories = _switchCategories(widget.category);
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList.length.toString());
    setState((){});
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown(){
    List<DropdownMenuItem<String>> items =  [];
    for(int i = 0; i < categories.length; i++){
      items.insert(0, DropdownMenuItem(child: Text(categories[i]), value: categories[i]));
    }
    setState(() {});
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final ProductCubit productCubit = BlocProvider.of<ProductCubit>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: const Icon(Icons.close, color: black,)),
        title: Text("اضافة منتج جديد", style: TextStyle(color: black,fontSize: 20,fontFamily: 'AA-GALAXY'),),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('اضافة صور',textAlign: TextAlign.center ,style: TextStyle(color: black, fontSize: 18),),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    IconButton(
                          icon: const Icon(Icons.add_circle),
                          iconSize: 40,
                          color: button,
                          onPressed: (){
                           selectImages();
                          },
                      ),
                  const SizedBox(width: 10,),
                  IconButton(
                      icon: const Icon(Icons.camera_alt),
                      iconSize: 40,
                      color: button,
                      onPressed: ()async{
                      XFile camFile =  await imagePicker.pickImage(source: ImageSource.camera);
                      setState(() {
                        if(camFile != null)
                        imageFileList.add(camFile);
                      });
                      },
                    ),
                ],
              ),
              _displayChild1(),
                         Padding(
                           padding: const EdgeInsets.all(12.0),
                           child: Row(mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Text('${widget.category}',style: TextStyle(color: button, fontSize: 17,fontFamily: 'AA-GALAXY'),),
                               const SizedBox(width: 10,),
                               Text(': القسم',style: TextStyle(color: black, fontSize: 18),),
                             ],
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                           child: Directionality(
                             textDirection: TextDirection.rtl,
                             child: Card(
                               elevation: 8,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: SearchableDropdown.single(
                                   items: getCategoriesDropdown(),
                                   value: _deviceName,
                                   style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 18,color: button),
                                   hint: "اختار نوع المنتج",
                                   searchHint: 'ابحث',
                                   closeButton: 'غلق',
                                   onChanged: (value) {
                                     setState(() {
                                       _deviceName = value;
                                     });
                                   },
                                   dialogBox: false,
                                   isExpanded: true,
                                   menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
                                 ),
                               ),
                             ),
                           ),
                         ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text('الماركة',textAlign: TextAlign.end ,style: TextStyle(color: black, fontSize: 18),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                    controller: nameController,
                    textDirection: Utils.isRTL(_brand.isNotEmpty ? _brand : nameController.text) ? TextDirection.rtl : TextDirection.ltr,
                    decoration: textInputDecoration2(''),
                    onChanged: (value){
                      setState(() {
                        _brand = value;
                      });
                    },
                    validator: (value) {
                      return value.isEmpty ? 'لازم تكتب اسم للمنتج' : null;
                    }
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text('الوصف',textAlign: TextAlign.end ,style: TextStyle(color: black, fontSize: 18),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                    controller: descriptionController,
                    textDirection: Utils.isRTL(_desc.isNotEmpty ? _desc : descriptionController.text) ? TextDirection.rtl : TextDirection.ltr,
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      setState(() {
                        _desc = value;
                      });
                    },
                    maxLines: null,
                    decoration: textInputDecoration2(''),
                    validator: (value) {
                      return value.isEmpty
                          ? 'لازم تكتب وصف للمنتج'
                          : value.length < 40 ?
                          ' وصف المنتج ضعيف'
                          : null;
                    }
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text('السعر',textAlign: TextAlign.end ,style: TextStyle(color: black, fontSize: 18),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: textInputDecoration2(''),
                  validator: (value){
                      return value.isEmpty? 'لازم تكتب سعر المنتج': null;
                  }
                ),
              ),
              const SizedBox(height: 20,),
              BlocConsumer<ProductCubit,ProductState>(
                  builder: (ctx,state){
               if(state is ProductLoading){
                      return spinKit;
                    } else {
                      return ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(button),elevation: MaterialStateProperty.all(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('اضافة المنتج',style: TextStyle(color: white,fontSize: 18),),
                        ),
                        onPressed: (){
                          validateAndUpload(context,productCubit);
                        },
                      );
                    }
                  },
                  listener: (ctx,state){
                    if(state is ProductAddedToWait){

                      BlocProvider.of<AdminsCubit>(context).updateAdminWaitNo(1,widget.alenaAdmin.id);
                      BlocProvider.of<AdminsCubit>(context).loadUserData();
                       showDialog(context: context, builder: (_){
                          return Dialog(
                              backgroundColor: white,
                              child: CustomAlertDialog(image: 'assets/good.png',text: 'تم',));
                        }).then((value) => Navigator.pop(context));

                    } else if(state is ProductLoadError){

                      showDialog(context: context, builder: (_){
                        return Dialog(
                            backgroundColor: white,
                            child: CustomAlertDialog(image: 'assets/bad.png',text: 'حدث خطأ ما حاول مرة اخرى',));
                      });

                    }
                    }),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayChild1() {
    return imageFileList.isNotEmpty ?
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: imageFileList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return imageFileList[index] == null ? SizedBox() :
              Stack(
                children: [
                  Image.file(File(imageFileList[index].path), fit: BoxFit.cover,),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: ()async{
                          setState(() {
                            imageFileList.removeAt(index);
                          });
                        },
                        child: CircleAvatar(
                            backgroundColor: button,
                            radius: 15,
                            child: Icon(Icons.close,size: 22,color: white,)
                        ),),
                    ),
                  ),
                ],
              );
            }),
      ) :
    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 150,
          width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          border: Border.all(color: black,width: 1),
          ),
        ),
    );
  }

  void validateAndUpload(BuildContext context,ProductCubit productCubit) async{
    if(_formKey.currentState.validate() && _deviceName.isNotEmpty && widget.category.isNotEmpty){
        if(imageFileList.isNotEmpty){
          if(widget.alenaAdmin.locations.isNotEmpty) {
            productCubit.emit(ProductLoading());
            List<String> urlList = [];
            String imageUrl1;
            for (XFile file in imageFileList) {
              UploadTask task = FirebaseStorage.instance.ref().child("${file.name}").putFile(File(file.path));
              TaskSnapshot snapshot = await task.then((snapshot) async {
                imageUrl1 = await snapshot.ref.getDownloadURL();
                urlList.add(imageUrl1);
                return snapshot;
              });
            }
            final String id = Uuid().v1();
            Product product = Product(id: id,
                images: urlList,
                price: double.parse(priceController.text),
                productName: _deviceName,
                description: descriptionController.text,
                vendor: widget.alenaAdmin,
                category: widget.category,
                city: widget.alenaAdmin.city,
                vendorId: widget.alenaAdmin.id,
                date: Utils.currentDate(),
                geoPoint: widget.alenaAdmin.locations.first.geoPoint,
                status: false,
                deviceName: nameController.text);
            productCubit.addProductToWaiting(product, id);
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (_) => EditInfoScreen(load: 4,title: 'الفروع',appUser: widget.alenaAdmin,)));
          }
        }else{
          Utils.showSnack('من فضلك اختار صورة','خطأ',context,button);
        }
    }else{
      Utils.showSnack('من فضلك اضف كل المعلومات','خطأ',context,button);
    }
  }

  List<String> _switchCategories(String category) {
    switch (category){
      case 'أثاث':
        return Utils.FURNITURE_LIST;
        break;
      case 'مفروشات':
        return Utils.MAFROSHAT_LIST;
        break;
      case 'اكسسوارات':
        return Utils.ACCESSORIES_LIST;
        break;
      case 'مستلزمات تنظيف':
        return Utils.CLEANING_STAFF_LIST;
        break;
      case 'رفائع و بلاستيكات':
        return Utils.PLASTICS_LIST;
        break;
      case 'الأجهزة الكهربائية الأساسية':
        return Utils.MAIN_ELECTRIC_DEVICES;
        break;
      case 'الأجهزة الكهربائية الاضافية':
        return Utils.ADDITIONAL_ELECTRIC_DEVICES;
        break;
      case 'أجهزة كهربائية صغيره للمطبخ':
        return Utils.ELECTRIC_SMALL_KITCHEN_DEV;
        break;
      case 'مستلزمات الملابس':
        return Utils.CLOTHES_TOOLS;
        break;
      case 'اللانجيري':
        return Utils.CLOTHES_LANGERY;
        break;
      case 'ملابس البيت':
        return Utils.CLOTHES_HOME;
        break;
      case 'ملابس الخروج':
        return Utils.CLOTHES_OUTING;
        break;
      case 'أدوات المطبخ':
        return Utils.KITCHEN_TOOLS;
        break;
      case 'أدوات التقديم':
        return Utils.KITCHEN_PROVIDERS;
        break;
      case 'أطقم المشروبات':
        return Utils.KITCHEN_DRINKS;
        break;
      case 'الأطباق':
        return Utils.KITCHEN_DISHES;
        break;
      case 'الصوانى و الطواجن':
        return Utils.KITCHEN_SAWANY;
        break;
      case 'الأوانى':
        return Utils.KITCHEN_AWANY;
        break;
      case 'الحلل و التوزيع':
        return Utils.KITCHEN_DISTRIBUTION;
        break;
      case 'المكياج':
        return Utils.PERSONAL_ACC_MAKEUP;
        break;
      case 'أدوات شخصية':
        return Utils.PERSONAL_ACC_TOOLS;
        break;
      case 'منتجات العناية بالبشرة':
        return Utils.PERSONAL_ACC_SKIN;
        break;
      case 'منتجات العناية بالجسم':
        return Utils.PERSONAL_ACC_BODY;
        break;
      case 'منتجات العناية بالشعر':
        return Utils.PERSONAL_ACC_HAIR;
        break;
      case 'الخزين':
        return Utils.HOUSE_LIST_STORE;
        break;
      case 'المنظفات':
        return Utils.HOUSE_LIST_CLEANING;
        break;
      default: return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
  }

}
