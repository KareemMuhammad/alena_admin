import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{

  static const String ID = "id";
  static const String FULL_NAME = "name";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String GENDER = "gender";
  static const String TOKEN = "token";
  static const String WEDDING_DATE = "weddingDate";
  static const String DONE_LIST = "doneList";
  static const String ADDITIONAL_LIST = "additionalList";
  static const String FAVORITES_LIST = "favoritesList";

   String id;
   String name;
   String email;
   String gender;
   String weddingDate;
   String token;
   List<dynamic> doneList;
   List<dynamic> additionalList;
   List<dynamic> favorites;

  AppUser({
      this.id,
      this.name,
      this.email,
      this.gender,
      this.weddingDate,
      this.token,
      this.doneList,
      this.additionalList,
      this.favorites});

  Map<String,dynamic> toMap()=>{
    ID : id ??'',
    FULL_NAME : name ??'',
    EMAIL : email ??'',
    GENDER : gender ??'',
    TOKEN : token ?? '',
    WEDDING_DATE : weddingDate ?? '',
    DONE_LIST : doneList.map((e) => e.toString()).toList() ?? [],
    ADDITIONAL_LIST : additionalList.map((e) => e.toString()).toList() ?? [],
    FAVORITES_LIST : favorites.map((e) => e.toString()).toList() ?? [],
  };

  AppUser.fromSnapshot(DocumentSnapshot doc){
    id = (doc.data() as Map)[ID] ?? '';
    name = (doc.data() as Map)[FULL_NAME] ?? '';
    email = (doc.data() as Map)[EMAIL] ?? '';
    gender = (doc.data() as Map)[GENDER] ?? '';
    token = (doc.data() as Map)[TOKEN] ?? '';
    weddingDate = (doc.data() as Map)[WEDDING_DATE] ?? '';
    doneList = (doc.data() as Map)[DONE_LIST] ?? [];
    additionalList = (doc.data() as Map)[ADDITIONAL_LIST] ?? [];
    favorites = (doc.data() as Map)[FAVORITES_LIST] ?? [];
  }

  AppUser.fromMap(Map<String,dynamic> map){
    id = map[ID] ?? '';
    name = map[FULL_NAME] ?? '';
    email = map[EMAIL] ?? '';
    gender = map[GENDER] ?? '';
    token = map[TOKEN] ?? '';
    weddingDate = map[WEDDING_DATE] ?? '';
    doneList = map[DONE_LIST] ?? [];
    additionalList = map[ADDITIONAL_LIST] ?? [];
    favorites = map[FAVORITES_LIST] ?? [];
  }

}