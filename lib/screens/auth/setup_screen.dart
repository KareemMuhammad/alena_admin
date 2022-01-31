import 'dart:io';
import 'package:alena_admin/database/admins/admin_state.dart';
import 'package:alena_admin/database/admins/admins_bloc.dart';
import 'package:alena_admin/database/auth_bloc/auth_cubit.dart';
import 'package:alena_admin/database/auth_bloc/auth_state.dart';
import 'package:alena_admin/models/vendor.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/country_constant.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SetupScreen extends StatefulWidget {
  final Vendor vendor;

  const SetupScreen({Key key, this.vendor}) : super(key: key);
  @override
  _SetupScreenState createState() => _SetupScreenState();
}
enum Page {BRAND,CONTACTS,LOCATIONS,LOGO}

class _SetupScreenState extends State<SetupScreen> {
  Page _page = Page.BRAND;
  final GlobalKey<FormState> _brandFormKey = GlobalKey<FormState>();
  List<dynamic> currentContacts = [];
  final TextEditingController textController = new TextEditingController();
  final TextEditingController brandController = new TextEditingController();
  String _brand = '';
  final GlobalKey<FormState> contactsFormKey = GlobalKey<FormState> ();
  String _chosenCountry = CountryConstant.ALL_CITIES[0];
  final ImagePicker imagePicker = ImagePicker();
  XFile imageFile;

  @override
  Widget build(BuildContext context) {
    final AdminsCubit adminCubit = BlocProvider.of<AdminsCubit>(context);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Wrap(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                color: white,
                alignment: Alignment.center,
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(primary: button),
                  ),
                  child: Stepper(
                    controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }){
                      return const SizedBox();
                    },
                    steps: getSteps(adminCubit),
                    type: StepperType.horizontal,
                    currentStep: _page.index,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Step> getSteps(AdminsCubit adminsCubit) =>
      [
        Step(
            isActive: _page.index >= 0,
            state: _page.index > 0 ? StepState.complete : StepState.indexed,
            title: Text('اسم التاجر',style: TextStyle(fontSize: 16,color: black,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
            content: _currentScreen(adminsCubit)
        ),
        Step(
            isActive: _page.index >= 1,
            state: _page.index > 1 ? StepState.complete : StepState.indexed,
            title: Text('جهات الاتصال',style: TextStyle(fontSize: 16,color: black,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
            content: _currentScreen(adminsCubit)
        ),
        Step(
            isActive: _page.index >= 2,
            state: _page.index > 2 ? StepState.complete : StepState.indexed,
            title: Text('الموقع',style: TextStyle(fontSize: 16,color: black,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
            content: _currentScreen(adminsCubit)
        ),
        Step(
            isActive: _page.index >= 3,
            state: _page.index > 3 ? StepState.complete : StepState.indexed,
            title: Text('الشعار',style: TextStyle(fontSize: 16,color: black,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
            content: _currentScreen(adminsCubit)
        ),
      ];

  Widget _currentScreen(AdminsCubit adminsCubit){
    switch(_page){
      case Page.BRAND:
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/brand.jpg',height: 100,width: 200,),
              ),
              customEditBrand('الاسم', TextInputType.emailAddress),
              const SizedBox(height: 20,),
              nextButton(checkBrand),
            ],
        );
        break;
      case Page.CONTACTS:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        _page = returnEnum(_page);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios, color: black,)),
                Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/contacts.jpg',height: 100,width: 200,),
            ),
            contactsWidget(),
            nextButton(checkContacts),
          ],
        );
        break;
      case Page.LOCATIONS:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        _page = returnEnum(_page);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios, color: black,)),
                Spacer(),
              ],
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Image.asset('assets/map.jpg',height: 100,width: 200,),
             ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField(
                  icon: Icon(Icons.add),
                  decoration: textInputDecoration2(''),
                  value: _chosenCountry ?? 'القاهرة',
                  items: CountryConstant.ALL_CITIES.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('$country',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)
                          ,textAlign: TextAlign.end,),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async{
                    setState(() => _chosenCountry = val );

                  },
                ),
              ),
            ),
            const SizedBox(height: 20,),
            nextButton(checkCountry),
          ],
        );
        break;
      case Page.LOGO:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        _page = returnEnum(_page);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios, color: black,)),
                Spacer(),
              ],
            ),
            const SizedBox(height: 20,),
            _displayChild1(),
            const SizedBox(height: 30,),
            BlocConsumer<AdminsCubit,AdminState>(
              listener: (BuildContext context, state) {
                if(state is AdminLoaded){
                  BlocProvider.of<AuthCubit>(context).emit(AuthSuccessful(state.appAdmin));
                }else if (state is AdminLoadError){
                    Utils.showToast('حدث خطأ حاول مرة اخرى');
                }
              },
              builder: (BuildContext context, state) {
                if(state is AdminLoading){
                  return spinKit;
                }else{
                  return GestureDetector(
                    onTap: ()async{
                      String url;
                      if(imageFile != null) {
                        UploadTask task = FirebaseStorage.instance.ref().child("${imageFile.name}").putFile(File(imageFile.path));
                        TaskSnapshot snapshot = await task.then((snapshot) async {
                          url = await snapshot.ref.getDownloadURL();
                          return snapshot;
                        });
                        if (url.isNotEmpty) {
                          Vendor newVendor = Vendor(
                              city: _chosenCountry,
                              brand: brandController.text,
                              contacts: currentContacts,
                              logo: url,
                              password: widget.vendor.password,
                              username: widget.vendor.username,
                              id: widget.vendor.id,
                              locations: [],
                              devices: [],
                              regions: [],
                              productNo: 0,
                              waitingNo: 0);
                          adminsCubit.updateCurrentVendor(newVendor);
                        }
                      }else{
                        Utils.showSnack('لازم تضيف صورة', 'خطأ', context, button);
                      }
                    },
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: button,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('متابعة',style: TextStyle(fontSize: 19,color: white,),
                              textAlign: TextAlign.center,),
                            const SizedBox(width: 8,),
                            const Icon(Icons.arrow_forward_ios,color: white,size: 18,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
        break;
      default : return const SizedBox();
    }
  }

  void checkCountry(){
    if(_chosenCountry.isNotEmpty){
      setState(() {
        _page = nextEnum(_page);
      });
    }
  }

  void checkContacts(){
    if(currentContacts.isNotEmpty){
      setState(() {
        _page = nextEnum(_page);
      });
    }else{
      Utils.showSnack('اكتب رقم واحد عالاقل', 'خطأ', context, button);
    }
  }
  void checkBrand(){
    if(_brandFormKey.currentState.validate()){
      setState(() {
        _page = nextEnum(_page);
      });
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
        height: 130,
        width: 130,
        decoration: BoxDecoration(
            border: Border.all(color: black,width: 1)
        ),
        child: IconButton(
          icon: const Icon(Icons.photo_camera_sharp),
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
         Column(
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
            if(contactsFormKey.currentState.validate()) {
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

  Widget nextButton(Function func){
    return GestureDetector(
      onTap: (){
        func();
        textController.clear();
      },
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: button,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('متابعة',style: TextStyle(fontSize: 19,color: white,),
                textAlign: TextAlign.center,),
              const SizedBox(width: 8,),
              const Icon(Icons.arrow_forward_ios,color: white,size: 18,),
            ],
          ),
        ),
      ),
    );
  }

  Widget customEditText(String text,TextInputType inputType){
    return Form(
      key: contactsFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                keyboardType: inputType,
                style: TextStyle(color: black,fontSize: 18,),
                decoration: textInputDecoration2(text),
                controller: textController,
                validator: (val) {
                  return val.isEmpty ? 'من فضلك املى الفراغ' : null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customEditBrand(String text,TextInputType inputType){
    return Form(
      key: _brandFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                textDirection: Utils.isRTL(_brand.isNotEmpty ? _brand : brandController.text) ? TextDirection.rtl : TextDirection.ltr,
                onChanged: (value){
                  setState(() {
                    _brand = value;
                  });
                },
                keyboardType: inputType,
                style: TextStyle(color: black,fontSize: 18,),
                decoration: textInputDecoration2(text),
                controller: brandController,
                validator: (val) {
                  return val.isEmpty ? 'من فضلك املى الفراغ' : null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Page nextEnum(Page value) {
    final nextIndex = (value.index + 1) % Page.values.length;
    return Page.values[nextIndex];
  }

  Page returnEnum(Page value) {
    final nextIndex = (value.index - 1) % Page.values.length;
    return Page.values[nextIndex];
  }

}
