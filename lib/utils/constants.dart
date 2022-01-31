import 'dart:convert';
import 'dart:math';
import 'package:alena_admin/main.dart';
import 'package:alena_admin/models/notification_model.dart';
import 'package:alena_admin/screens/wrapper_screen.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'shared.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class Utils{

  ////////////////////////////////////////////////////////////// Main Lists /////////////////////////////////////////////////////////////
  static const List<String> MAIN_CATEGORIES_LIST = ['أثاث','أجهزة كهربائية','مفروشات','أدوات مطبخ','اكسسوارات', 'رفائع و بلاستيكات','مستلزمات تنظيف','مستلزمات شخصية','ملابس','مستلزمات المنزل'];
  static const List<String> FURNITURE_LIST = ['غرفة نوم','غرفة السفرة','غرفة الأطفال','الأنتريه','الركنة','الصالون','غرفة المكتب','المطبخ',];
  static const List<String> MAFROSHAT_LIST = ['سجاد','كوفرته','طقم برانص','اطقم فوط','مفرش سرير العروسة','لحاف فايبر','بطانية مجوز','بطانية مفرد', 'ستائر','مرتبة','مخدات','دفاية سرير','ملايات سرير','ملايات سرير اطفال','دفاية و كوفرته اطفال','بطانية و لحاف اطفال','مفرش سفره','مفارش طرابيزة','مفرش تسريحة', 'مفارش دولاب','مفارش ثلاجة','مفارش نيش','حافظة كنب','حافظة سجاد'];
  static const List<String> ACCESSORIES_LIST = ['نجف','اباجورات','فازات','بورتريهات','ورد','انتيكات','شموع','ساعة حائط'];
  static const List<String> CLEANING_STAFF_LIST = ['مقشة','مساحة','جردل','شرشوبة','جاروف','زعافة','فرشة سجاد','فرشة حمام','مساحة زجاج','فوط تنظيف','سلاكة بلاعة'];
  static const List<String> PLASTICS_LIST = ['ارفف الحمام','ستارة بانيو','ستارة شباك حمام','سجاد حمام','كرسي حمام','عليقة ملابس','صفاية بانيو','ليفة و بونيه شاور','سلات قمامة','سلة بصل','حبل غسيل','سبت غسيل','طبق لم الغسيل','مشابك','مشمع غسيل','طرابيزة مكواه','بخاخات','سبت بلكونة'];
  static List<String> allDevicesList = PERSONAL_ACC_TOOLS + PERSONAL_ACC_MAKEUP + PERSONAL_ACC_BODY + PERSONAL_ACC_SKIN + PERSONAL_ACC_HAIR + CLOTHES_OUTING + CLOTHES_HOME +
      CLOTHES_LANGERY + CLOTHES_TOOLS+ MAIN_ELECTRIC_DEVICES + ADDITIONAL_ELECTRIC_DEVICES + ELECTRIC_SMALL_KITCHEN_DEV + KITCHEN_DISTRIBUTION + KITCHEN_AWANY + KITCHEN_SAWANY +
      KITCHEN_DISHES + KITCHEN_DRINKS + KITCHEN_PROVIDERS + KITCHEN_TOOLS + HOUSE_LIST_CLEANING + HOUSE_LIST_STORE  + ACCESSORIES_LIST + CLEANING_STAFF_LIST + PLASTICS_LIST + MAFROSHAT_LIST + FURNITURE_LIST;

  ////////////////////////////////////////////////////////// Electric ////////////////////////////////////////////////////////////////////////////
  static const List<String> ELECTRIC_DEVICES = ['الأجهزة الكهربائية الأساسية','الأجهزة الكهربائية الاضافية','أجهزة كهربائية صغيره للمطبخ'];
  static const List<String> MAIN_ELECTRIC_DEVICES = ['ثلاجة','غسالة','بوتجاز','سخان','مراوح','تكيفات','شاشة تلفزيون','شفاط مطبخ','فرن كهرباء','ميكرويف'];
  static const List<String> ADDITIONAL_ELECTRIC_DEVICES = ['مكنسة كهربائية','غسالة اطباق','ديب فريزر','مجفف ملابس','مبرد مياه','غسالة اطفال','مكواه بخار','كشاف نور','صاعق ناموس','شفاط حمام'];
  static const List<String> ELECTRIC_SMALL_KITCHEN_DEV = ['شواية كهرباء','قلاية هوائية بدون زيت','قلاية كهربائية','كيتشين ماشين','خلاط','كبة','عجانة','مضرب بيض كهربائي','حلة رز','ماكينة اسبريسو','عصارة فواكه','خلاط يدوي','مضرب نسكافية','ماكينة تحميص التوست'];

  ///////////////////////////////////////////////////////////// Kitchen /////////////////////////////////////////////////////////////////////////////////////////////
  static const List<String> KITCHEN_DEVICES = ['الحلل و التوزيع','الأوانى','الصوانى و الطواجن','الأطباق','أطقم المشروبات','أدوات التقديم','أدوات المطبخ'];
  static const List<String> KITCHEN_DISTRIBUTION = ['طقم حلل ستالس','طقم حلل تيفال','طقم حلل سيراميك','طقم حلل جيرانيت','حلة مكرونة','حلة ضغط','طقم توزيع ستانلس','طقم توزيع خشب','طقم توزيع بلاستيك','طقم توزيع سيليكون'];
  static const List<String> KITCHEN_AWANY = ['طقم طاسات استانلس','طقم طاسات تيفال','طقم طاسات جيرانيت','طاسة تحمير','شواية','براد','طقم كنك','لبانه','قدرة فول','صفاية زيت'];
  static const List<String> KITCHEN_SAWANY = ['طقم بايركس','صواني فرن تيفال','صواني فرن المونيوم','صواني بيتزا','صواني كاب كيك','صواني كيك','طقم سيليكون للفرن','طواجن فرن احجام'];
  static const List<String> KITCHEN_DISHES = ['طقم اطباق صيني','طقم اطباق اركوبال','طقم اطباق عشاء','طقم اطباق ميلامين','اطباق سرفيس','طقم اطباق حلويات','طقم خشاف','سلاطيم الشوربة','سلاطين السلطات'];
  static const List<String> KITCHEN_DRINKS = ['طقم الشاي','طقم فناجين قهوه','طقم شربات','طقم عصير','طقم كاسات','طقم مياه','طقم مجات','دورق عصائر','زجاجات مياه'];
  static const List<String> KITCHEN_PROVIDERS = ['صواني تقديم ستانلس','صواني ميلامين','صينية عشاء كبيرة','شمطة معالق','ترمس شاي','طقم ملاحات','سكرية','بونبونيرة','طفايات','طبق فواكه','طبق تسالي'];
  static const List<String> KITCHEN_TOOLS = ['طقم ساكاكين','قطاعة بيتزا','مقشرة خضار','مخرطة ملوخيه','مبشرة','مقاور محشي','مفرمة ثوم','هراسة بطاطس','مدق كفنة','لوح تقطيع','عصارة ليمون','كسارة بندق','اسياخ شيش','هون','مبشرة جوز الطيب','طقم مقصات','فتاحة علب','شياطة','ولاعات','اطباق غويطة للعجن','نشابة','دورق معيار','منخل دقيق','سبتيولا','مضرب بيض','فرشة دهان صواني','بخاخة زيت','جوانتي حراري','طقم توابل','معالق توابل','برطمانات تخزين','علب ثلاجة بايركس','علب ثلاجة بلاستيك','عياشة','طبق غسيل رز','مصافي','صفاية حوض','صفاية معالق','حامل مجات','حامل مناديل','قاعدة ( انبوبة - غسالة )','غطاء ( انبوبة - غسالة )','مريلة','ستارة مطبخ','مفارش مطبخ'];

  //////////////////////////////////////////////////////////////// مستلزمات المنزل /////////////////////////////////////////////////////////////////////
  static const List<String> HOUSE_LIST = ['المنظفات','الخزين'];
  static const List<String> HOUSE_LIST_CLEANING = ['ديتول','منظف ارضيات','مسحوق غسيل','معطر غسيل','كلوروكس','صابون غسيل مواعين','مذيب دهون','ملمع خشب','ملمع زجاج','معطر جو','بخور','مناديل مطبخ','ورق فويل','ورق زبده','بلاستيك تغليف','اكياس قمامة','اكياس اكل','فوط مطبخ','ليف و سلك مواعين'];
  static const List<String> HOUSE_LIST_STORE = ['زيت قلية','زيت ذرة','زيت زيتون','زبدة','سمنة','خل','ارز ابيض','ارز بسمتي','مكرونة','دقيق','نشا','سكر','ملح','بهارات متنوعة','بقسماط','خميرة','بيكينج باودر','فانيلا','كاتشب','مايونيز','مسطردة','صويا صوص','صلصة طماطم','شاي','قهوه','نسكافية','خضراوات الطبخ','خضراوات السلطة','فاكهه','لحوم','عيش','حليب','جبن','زبادي','بيض','عسل','مربى','طحينه','مخللات'];

  ////////////////////////////////////////////////////////////// مستلزمات شخصية ///////////////////////////////////////////////////////////////////////
  static const List<String> PERSONAL_ACCESSORIES = ['أدوات شخصية','المكياج','منتجات العناية بالبشرة','منتجات العناية بالجسم','منتجات العناية بالشعر'];
  static const List<String> PERSONAL_ACC_TOOLS = ['مشط','فرشه','مراية صغيرة','شنطة مكياج','مجفف شعر','مكواة شعر','ماكينة الشمع','فرش اسنان','شباشب','لكلوك شتوي'];
  static const List<String> PERSONAL_ACC_MAKEUP = ['كريم اساس','بودرة تثبيت','مورد خدود','ايلاينر','كحل','قلم او بودرة حواجب','ايشادو','ماسكرة','روج بألوان مختلفة','فرش','اسفنجه ( بيوتي بلندر )','مانيكير'];
  static const List<String> PERSONAL_ACC_BODY = ['كريم مرطب لليدين','كريم مرطب للقدمين','كريم مرطب للوجه','غسول للوجه','تونر للوجه','سيرم للوجه','صن بلوك','مزيل مكياج','ماسكات للوجه','مرطب شفاه'];
  static const List<String> PERSONAL_ACC_SKIN = ['شاور جل للجسم','غسول المنطقة الحساسة','بادي لوشن للجسم','بادي ميست للجسم','مزيل عرق','عطر','مسك الطهاره','مخمرية للمنطقة الحساسة','معجون اسنان','غسول للفم'];
  static const List<String> PERSONAL_ACC_HAIR = ['شامبو','بلسم','حمام كريم','حمام زيت','كريم للشعر','زيت للشعر','سيرم للشعر','بديل الزيت','جيل للشعر','معطر للشعر'];

  //////////////////////////////////////////////////////////// ملابس ///////////////////////////////////////////////////////////////////////
  static const List<String> CLOTHES = ['ملابس الخروج','ملابس البيت','اللانجيري','مستلزمات الملابس'];
  static const List<String> CLOTHES_OUTING = ['فساتين','بنطلونات جينز','بنطلونات قماش','جيب','قمصان','بلوزات صيفي','تيشيرتات قطن','اندر شيرت قطن','بلوفرات شتوي','جواكت شتوي'];
  static const List<String> CLOTHES_HOME = ['بيجامات شورت','بيجامات صيفي','جلابيات صيفي','طقم استقبال صيفي','بيجامات شتوي','بيجامات دفاية','جلابيات شتوي','طقم استقبال شتوي','اسدال صلاه'];
  static const List<String> CLOTHES_LANGERY = ['قميص ستان و روب','قميص عادي و روب','عدد قميص نوم قصير','عدد قميص نوم طويل','طقم لانجيري العروسة','بيجامات ستان شورت','بيجامات ستان بنطلون','عدد بانتي ( بيت - خروج )','عدد برا ( بيت - خروج )','عدد اطقم بانتي و برا'];
  static const List<String> CLOTHES_TOOLS = ['احذية','كوتشيهات','بوتات','صنادل','سليبرز','شنطة يد','شنطة كروس','شنطة ظهر','شنطة وسط','محفظة','احزمة','طرح','بندانات','شرابات','نظارات','حلقان','خواتم','سلاسل','غوايش','انسيال','توك','بنس','دبابيس'];

  /////////////////////////////////////////////////////////////// constants //////////////////////////////////////////////////////////////
  static const String SHARED_KEY = "newUserKey";

  static const String SHOWCASE_KEY = "showcaseKey";

  static const String APP_ICON_URL = "https://firebasestorage.googleapis.com/v0/b/alena-ed5f1.appspot.com/o/app_icon2.jpg?alt=media&token=b0bb438d-54bc-4827-8b2e-67db5fefe7ae";

  static const String SHARED_SELECTED_CATEGORIES_KEY = "selectedCategoriesKey";

  static const String SHARED_SELECTED_INDEXES_KEY = "selectedIndexesKey";

  static const List<String> MAIN_CATEGORIES_IMAGES = ['assets/main/furniture.jpg','assets/main/electric.jpg','assets/main/mafroshat.jpg','assets/main/kitchen.jpg','assets/main/accessories.jpg','assets/main/plastics.jpg','assets/main/cleaning.jpg','assets/main/personal.jpg','assets/main/clothes.jpg','assets/main/house.jpg'];

  static const List<String> SUB_CATEGORIES_IMAGES = ['assets/sub/furniture2.jpg','assets/sub/electric2.jpg','assets/sub/mafroshat2.jpg','assets/sub/kitchen2.jpg','assets/sub/accessories2.jpg','assets/sub/plastics2.jpg','assets/sub/cleaning2.jpg','assets/sub/personal2.jpg','assets/sub/clothes2.jpg','assets/main/house.jpg'];

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String FCM_URL = 'https://fcm.googleapis.com/fcm/send';

  static showSnack(String text,String title,BuildContext context,Color color)async{
    await Flushbar(
      messageText: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Text('$text',style: TextStyle(color: white,fontFamily: '',fontSize: 17),)),
        titleText: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Text('$title',style: TextStyle(color: white,fontFamily: '',fontSize: 17,fontWeight: FontWeight.w300),)),
        backgroundColor: color,
        icon: Icon(Icons.info_outline,color: white,),
        duration: Duration(seconds: 1),
    ).show(context);
  }

  static showToast(String text){
    Fluttertoast.showToast(
      msg: "$text",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: button,
      textColor: white,
      fontSize: 18.0,
    );
  }

  static bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  static Future<String> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = new Coordinates(position.latitude, position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print('${first.addressLine}');
      return '${first.addressLine}';
    }catch(e){
      print(e.toString());
      return '';
    }
  }

  static Future<Coordinates> getCoordinates(String query)async{
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    return first.coordinates;
  }

  static String currentDate(){
    DateTime currentPhoneDate = DateTime.now();
    String dateFormat = DateFormat('yyyy-MM-dd').format(currentPhoneDate);
    String timeFormat = DateFormat('kk:mm:ss').format(currentPhoneDate);
    String format = '$dateFormat $timeFormat';
    return format;
  }

  static int dateDifference(String date,String time){
    return DateTime(int.parse(date.split('-')[0]),int.parse(date.split('-')[1],)
        ,int.parse(date.split('-')[2]),int.parse(time.split(':')[0]),
        int.parse(time.split(':')[1]),int.parse(time.split(':')[2])).millisecondsSinceEpoch;
  }

  static Future showNormalNotification(String title) async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
            ) async {

        });

    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            navigatorKey.currentState.push(MaterialPageRoute(builder: (_)=> WrapperScreen()));
          }
        });
    String id = Uuid().v4();
    var android = AndroidNotificationDetails(id, 'Alena', title,playSound: true,priority: Priority.high,importance: Importance.max,);
    var iOS = IOSNotificationDetails(presentSound: true,subtitle: 'علينا');
    var platform = NotificationDetails(iOS: iOS,android: android);

    await _flutterLocalNotificationsPlugin.schedule(Random().nextInt(100000), title,
        'علينا', DateTime.now().add(Duration(seconds: 1)),platform);
  }

  static Future<void> sendPushMessage(NotificationModel model,String token) async {
    var client = http.Client();
    print('${model.id}');
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await client.post(
        Uri.parse(FCM_URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${remoteConfigService.getKey}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              NotificationModel.BODY: '${model.body}',
              NotificationModel.TITLE: '${model.title}',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              NotificationModel.BODY: '${model.body}',
              NotificationModel.TITLE: '${model.title}',
              'status': 'done',
              NotificationModel.ROUTE : '${model.route}',
              NotificationModel.ICON : '${model.icon}',
              NotificationModel.TIME : '${model.time}',
              NotificationModel.VENDOR_ID : '${model.vendorId}',
              NotificationModel.PRODUCT_ID : '${model.productId}',
              NotificationModel.NOT_ID : '${model.id}'
            },
            'to': token,
          },
        ),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e.toString());
    }
  }

}
