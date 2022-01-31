import 'dart:io';
import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/database/products/product_repository.dart';
import 'package:alena_admin/database/products/product_state.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/categories_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key key, this.product}) : super(key: key);
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ProductRepository database = ProductRepository();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String category = '';
  bool isLoading = false;
  String _deviceName = '';
  List<XFile> imageFileList = [];
  List<String> deletedImages = [];
  List<dynamic> currentImages = [];
  List<String> categories;
  final ImagePicker imagePicker = ImagePicker();
  String _brand = '';
  String _desc = '';

  @override
  void initState() {
    super.initState();
    currentImages.addAll(widget.product.images);
    categories = _switchCategories(widget.product.category);
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
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(categories[i]), value: categories[i]));
      });
    }
    return items;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close, color: black,)),
        title: Text("تعديل المنتج", style: TextStyle(color: black,fontSize: 20),),
      ),
      backgroundColor: white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: currentImages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return currentImages[index] == null ? SizedBox() :
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: currentImages[index],
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Image.asset('assets/image-not-found.png'),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: ()async{
                                  setState(() {
                                    deletedImages.add(currentImages[index]);
                                    currentImages.removeAt(index);
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
              ),
              imageFileList.isNotEmpty?
              Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: imageFileList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(imageFileList[index].path), fit: BoxFit.cover,);
                        }),
                  ): const SizedBox(),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    iconSize: 40,
                    color: button,
                    onPressed: (){
                      selectImages();
                    },
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
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

              ElevatedButton(
                onPressed: (){
                  showDialog(context: context, builder: (_){
                    return Dialog(
                        backgroundColor: white,
                        child: Wrap(
                          children: [
                            CategoriesDialog(),
                          ],
                        ));
                  },barrierDismissible: false).then((value) {
                    if(value != null) {
                      setState(() {
                        category = value;
                        categories = _switchCategories(category);
                        _deviceName = null;
                      });
                    }
                  });
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(white),elevation: MaterialStateProperty.all(4)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${category.isEmpty ? widget.product.category : category}',style: TextStyle(color: button, fontSize: 17),),
                      const SizedBox(width: 10,),
                      Text(': القسم',style: TextStyle(color: Colors.grey[800], fontSize: 18),),
                    ],
                  ),
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
                        value: _deviceName == null ? '' : _deviceName,
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
                    onChanged: (value){
                      setState(() {
                        _brand = value;
                      });
                    },
                    decoration: textInputDecoration2(widget.product.deviceName),
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
                    decoration: textInputDecoration2(widget.product.description),
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
                    decoration: textInputDecoration2(widget.product.price.toString()),
                    validator: (value){
                      return value.isEmpty? 'لازم تكتب سعر المنتج': null;
                    }
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(button),elevation: MaterialStateProperty.all(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('تعديل المنتج',style: TextStyle(color: white,fontSize: 18),),
                ),
                onPressed: (){
                  validateAndUpload(context);
                },
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  void manageDeleteUrls()async{
    for(String url in deletedImages){
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
  }

  void validateAndUpload(BuildContext context) async{
      if(currentImages.isNotEmpty || imageFileList.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        List<dynamic> urlList = currentImages;
        String imageUrl1;
        if (imageFileList != null && imageFileList.isNotEmpty)
          for (XFile filePath in imageFileList) {
            UploadTask task = FirebaseStorage.instance.ref().child(
                "${filePath.name}").putFile(File(filePath.path));
            TaskSnapshot snapshot = await task.then((snapshot) async {
              imageUrl1 = await snapshot.ref.getDownloadURL();
              urlList.add(imageUrl1);
              return snapshot;
            });
          }

        if (deletedImages.isNotEmpty) {
          manageDeleteUrls();
        }
        if (_deviceName == null) {
          Utils.showSnack('اختار نوع المنتج', 'خطأ', context, button);
        } else{
          Product product = Product(id: widget.product.id,
              images: urlList,
              price: priceController.text.isEmpty ? widget.product.price : double.parse(priceController.text),
              productName: _deviceName.isEmpty ? widget.product.productName : _deviceName,
              description: descriptionController.text.isEmpty ? widget.product.description : descriptionController.text,
              vendor: widget.product.vendor,
              category: category.isEmpty ? widget.product.category : category,
              city: widget.product.vendor.city,
              vendorId: widget.product.vendorId,
              geoPoint: widget.product.geoPoint,
              status: widget.product.status,
              date: widget.product.date,
              deviceName: nameController.text.isEmpty ? widget.product.deviceName : nameController.text);

        bool validity = await database.updateProductInfo(
            product, widget.product.id);
        setState(() {
          isLoading = false;
        });
        if (validity) {
          BlocProvider.of<ProductCubit>(context).emit(ProductUpdated());
          Utils.showSnack('تم تعديل المنتتج', 'تم', context, Colors.green[700]);
          Navigator.pop(context);
        } else {
          BlocProvider.of<ProductCubit>(context).emit(ProductNotUpdated());
          Utils.showSnack('من فضلك حاول مرة أخرى', 'خطأ', context, button);
          setState(() {
            isLoading = false;
          });
        }
      }
      }else{
        Utils.showSnack('من فضلك اختار صورة','خطأ',context,button);
        setState(() {
          isLoading = false;
        });
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
