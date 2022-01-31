class Region{

  static const String NAME = "city_name_ar";

  String name;

  Region({this.name});

  Region.fromMap(Map<String,String> map){
    name = map[NAME] ?? '';
  }

}