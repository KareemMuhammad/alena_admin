import 'dart:io';
import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/models/vendor_locations.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/screens/auth/regions_screen.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/country_constant.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/shared.dart';

class EditInfoScreen extends StatefulWidget {
  final int load;
  final String title;
  final Vendor appUser;

  const EditInfoScreen({Key key, this.load, this.title, this.appUser}) : super(key: key);
  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final TextEditingController textController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<dynamic> currentContacts = [];
  List<VendorLocations> currentLocations = [];
  List<dynamic> countries = [];
  String _chosenCountry = CountryConstant.ALL_CITIES[0];
  final ImagePicker imagePicker = ImagePicker();
  XFile imageFile;
  dynamic region;
  String _brand = '';

  @override
  void initState() {
    super.initState();
    if(widget.load == 3) {
      currentContacts.addAll(widget.appUser.contacts);
    }else if(widget.load == 4){
      currentLocations.addAll(widget.appUser.locations);
    }
  }


  void selectImages() async {
    final XFile selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      imageFile = selectedImages;
    }
    print("Image :" + imageFile.toString());
    setState((){});
  }


  @override
  Widget build(BuildContext context) {
    final AdminsCubit adminCubit = BlocProvider.of<AdminsCubit>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('${widget.title}',style: TextStyle(fontSize: 23,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             const SizedBox(height: 40,),
              _loadScreen(widget.appUser),
             const SizedBox(height: 20,),
             isLoading ? spinKit
             : Padding(
                padding: const EdgeInsets.all(10),
                child: RaisedButton(
                  color: button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  onPressed: () async{
                    performUpdate(adminCubit,context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('حفظ',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,fontFamily: 'AA-GALAXY'),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void performUpdate(AdminsCubit adminCubit,BuildContext context)async{
    switch(widget.load){
      case 0:
        {
          if (formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });
            adminCubit.updateAdminInfo(textController.text,Vendor.BRAND);
            Navigator.pop(context);
          }
        }
        break;
      case 1:
        {
          setState(() {
            isLoading = true;
          });
          adminCubit.updateAdminInfo(_chosenCountry,Vendor.CITY);
          Navigator.pop(context);
        }
        break;
      case 2:
        {
          if(imageFile != null){
            setState(() {
              isLoading = true;
            });
            await FirebaseStorage.instance.refFromURL(widget.appUser.logo).delete();
            String url;
            UploadTask task = FirebaseStorage.instance.ref().child("${imageFile.name}").putFile(File(imageFile.path));
            TaskSnapshot snapshot = await task.then((snapshot) async {
              url = await snapshot.ref.getDownloadURL();
              return snapshot;
            });
            adminCubit.updateAdminInfo(url,Vendor.LOGO);
            Navigator.pop(context);
          }else{
            Utils.showSnack('من فضلك اضف صورة','خطأ',context,button);
          }
        }
        break;
      case 3:
        {
          if(currentContacts.isNotEmpty){
            setState(() {
              isLoading = true;
            });
            adminCubit.updateContacts(currentContacts);
            Navigator.pop(context);
          }else{
            Utils.showSnack('من فضلك اضف جهة اتصال','خطأ',context,button);
          }
        }
        break;
      case 4:
        {
          if(currentLocations.isNotEmpty){
            setState(() {
              isLoading = true;
            });
            adminCubit.updateLocations(currentLocations);
            adminCubit.updateRegions(region);
            Navigator.pop(context);
          }else{
            Utils.showSnack('من فضلك اضف فرع واحد على الأقل','خطأ',context,button);
          }
        }
        break;
    }
  }

  Widget _loadScreen(Vendor appUser){
    switch(widget.load){
      case 0 :
        return customEditText(appUser.brand,TextInputType.emailAddress);
        break;
      case 1 :
        return Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonFormField(
                decoration: textInputDecoration2(''),
                value: _chosenCountry ?? 'القاهرة',
                items: CountryConstant.ALL_CITIES.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Text('$country',style: TextStyle(fontSize: 18),),
              );
            }).toList(),
              onChanged: (val) => setState(() => _chosenCountry = val ),
            ),
          ),
        );
        break;
      case 2 :
        return _displayChild1();
        break;
      case 3 :
        return contactsWidget();
        break;
      case 4 :
        return locationsWidget();
        break;
      default : return Container();
    }
  }

  Widget customEditText(String text,TextInputType inputType){
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: button,
          elevation: 2,
          child: MaterialButton(
              minWidth: SizeConfig.screenWidth,
              onPressed: () {

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textDirection: Utils.isRTL(_brand.isNotEmpty ? _brand : textController.text) ? TextDirection.rtl : TextDirection.ltr,
                  onChanged: (value){
                    setState(() {
                      _brand = value;
                    });
                  },
                  keyboardType: inputType,
                  style: TextStyle(color: black,fontSize: 18,),
                  decoration: textInputDecoration2(text),
                  controller: textController,
                  validator: (val) {
                    return val.isEmpty ? 'من فضلك املىء الفراغ' : null;
                  },
                ),
              ),
          ),
        ),
      ),
    );
  }

  Widget _displayChild1() {
    return imageFile != null ?
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Image.file(File(imageFile.path), fit: BoxFit.cover,height: 130,width: 130,),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: ()async{
                    setState(() {
                      imageFile = null;
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
        )) :
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        height: 130,
        width: 130,
        decoration: BoxDecoration(
            border: Border.all(color: black,width: 1)
        ),
        child: IconButton(
          icon: Icon(Icons.photo_camera_sharp),
          iconSize: 40,
          color: button,
          onPressed: (){
            selectImages();
          },
        ),
      ),
    );
  }

  Widget contactsWidget(){
      return Column(
        children: [
          currentContacts == null || currentContacts.isEmpty ?
          const SizedBox()
              : Column(
            children: [
              ...(currentContacts).map((contact) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                          setState(() {
                            currentContacts.remove(contact);
                          });
                        },
                        color: button,
                      ),
                      Text('$contact',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
                        ,textAlign: TextAlign.center,),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
          customEditText('رقم جديد',TextInputType.number),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: (){
              if(formKey.currentState.validate()) {
                setState(() {
                  currentContacts.add(textController.text);
                });
              }
            },
            color: button,
            iconSize: 30,
          ),
        ],
      );
  }

  Widget locationsWidget(){
    return Column(
      children: [
        currentLocations == null || currentLocations.isEmpty ?
        const SizedBox()
            : Column(
          children: [
            ...(currentLocations).map((location) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                          currentLocations.remove(location);
                        });
                      },
                      color: button,
                    ),
                    Expanded(
                      child: Text('${location.locationName}',style: TextStyle(fontSize: 18,color: black,fontFamily: 'AA-GALAXY')
                        ,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text('المنطقة',textAlign: TextAlign.end ,style: TextStyle(color: black, fontSize: 18),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
              readOnly: true,
              decoration: textInputDecoration2(region ?? ''),
              onTap: ()async{
                List<Map<String,String>> regionMap = getCategoryOfDevice(widget.appUser.city);
               dynamic result = await navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => RegionsScreen(regions: regionMap,)));
               if(result != null){
                 setState(() {
                   region = result;
                 });
               }
              },

          ),
        ),
          customEditText('العنوان',TextInputType.emailAddress),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: ()async{
            if(formKey.currentState.validate() && region != null) {
               Coordinates coordinates = await Utils.getCoordinates(textController.text);
              VendorLocations vendorLoc = VendorLocations(locationName: textController.text,
                  geoPoint: GeoPoint(coordinates.latitude,coordinates.longitude),address: region);
              setState(() {
                currentLocations.add(vendorLoc);
              });
            }else{
              Utils.showToast('اختار المنطقة');
            }
          },
          color: button,
          iconSize: 30,
        ),
      ],
    );
  }

  List<Map<String,String>> getCategoryOfDevice(String value) {

    if(CountryConstant.ALL_CITIES[0] == value){
      return CountryConstant.CAIRO_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[1] == value){
      return CountryConstant.ALEX_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[2] == value){
      return CountryConstant.DAMIETTA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[3] == value){
      return CountryConstant.ISMAILIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[4] == value){
      return CountryConstant.SHARKIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[5] == value){
      return CountryConstant.GIZA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[6] == value){
      return CountryConstant.MENOFIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[7] == value){
      return CountryConstant.QALYIUBIYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[8] == value){
      return CountryConstant.SUEZ_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[9] == value){
      return CountryConstant.MATROUH_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[10] == value){
      return CountryConstant.KAFR_SHEIKH_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[11] == value){
      return CountryConstant.QENA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[12] == value){
      return CountryConstant.FAYOUM_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[13] == value){
      return CountryConstant.GHARBIYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[14] == value){
      return CountryConstant.ASWAN_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[15] == value){
      return CountryConstant.SOHAG_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[16] == value){
      return CountryConstant.DAKAHLIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[17] == value){
      return CountryConstant.ASSIUT_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[18] == value){
      return CountryConstant.SOUTH_SINAI_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[19] == value){
      return CountryConstant.NORTH_SINAI_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[20] == value){
      return CountryConstant.LUXOR_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[21] == value){
      return CountryConstant.BEHIRA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[22] == value){
      return CountryConstant.RED_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[23] == value){
      return CountryConstant.BENI_SUEF_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[24] == value){
      return CountryConstant.PORT_SAID_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[25] == value){
      return CountryConstant.MINYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[26] == value){
      return CountryConstant.VALLEY_REGIONS;
    }else{
      return [];
    }
  }


  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

}
