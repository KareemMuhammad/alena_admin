import 'package:alena_admin/models/region.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegionsScreen extends StatefulWidget {
  final List<Map<String,String>> regions;

  const RegionsScreen({Key key, this.regions}) : super(key: key);

  @override
  _RegionsScreenState createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen> {
  List<Region> convertedList;

  @override
  void initState() {
    super.initState();
    convertedList = locationsList(widget.regions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: button,
          elevation: 2,
          title: Text('المنطقة',style: TextStyle(fontSize: 20,color: white,fontFamily: 'AA-GALAXY',wordSpacing: 2)
            ,textAlign: TextAlign.center,),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: convertedList.length,
                  itemBuilder: (ctx,index){
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: (){
                                Navigator.pop(context,'${convertedList[index].name}');
                              },
                              child: Text(convertedList[index].name,style: TextStyle(fontSize: 19,color: black),)
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(height: 2,color: Colors.grey[800],),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        )
    );
  }

  List<Region> locationsList (List<Map<String,String>> locations){
    List<Region> convertedList = [];
    for(Map item in locations){
      convertedList.add(Region.fromMap(item));
    }
    return convertedList;
  }
}
