import 'package:alena_admin/database/category_cubit/category_cubit.dart';
import 'package:alena_admin/utils/constants.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesDialog extends StatefulWidget {
  @override
  _CategoriesDialogState createState() => _CategoriesDialogState();
}

class _CategoriesDialogState extends State<CategoriesDialog> {
  @override
  Widget build(BuildContext context) {
    final CategoryCubit categoryCubit = BlocProvider.of<CategoryCubit>(context);
    return Container(
      height: SizeConfig.screenHeight * 0.8,
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text('القسم',style: TextStyle(fontSize: 18,color: black,fontFamily: 'AA-GALAXY',wordSpacing: 2)
              ,textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 10,),
           ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Utils.MAIN_CATEGORIES_LIST.length,
                  itemBuilder: (ctx,index){
                  return index == 1 ||  index == 3 || index == 7 || index == 8 || index == 9 ?
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            ExpansionTile(
                              title: Text('${Utils.MAIN_CATEGORIES_LIST[index]}',style: TextStyle(color: black,fontSize: 18),),
                              textColor: black,
                              backgroundColor: white,
                              children: [
                                _getSubCategories(index,categoryCubit),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(height: 2,color: Colors.grey[800],),
                            ),
                          ],
                        ),
                      )
                      : Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: GestureDetector(
                                  onTap: (){
                                   // categoryCubit.setCategory(Utils.MAIN_CATEGORIES_LIST[index]);
                                    Navigator.pop(context,'${Utils.MAIN_CATEGORIES_LIST[index]}');
                                  },
                                  child: Text('${Utils.MAIN_CATEGORIES_LIST[index]}',style: TextStyle(color: black,fontSize: 18),)),
                             ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(height: 2,color: Colors.grey[800],),
                            ),
                          ],
                        ),
                      );
                  }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(white),elevation: MaterialStateProperty.all(2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('خروج',style: TextStyle(color: black,fontSize: 16),),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _getSubCategories(int index,CategoryCubit categoryCubit) {
    switch (index){
      case 1:
        return Column(
          children: [
            ...(Utils.ELECTRIC_DEVICES).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: (){
                     // categoryCubit.setCategory(device);
                      Navigator.pop(context,'$device');
                    },
                    child: Text('$device',style: TextStyle(color: black,fontSize: 18),)),
              );
            })
          ],
        );
        break;
      case 3:
        return Column(
          children: [
            ...(Utils.KITCHEN_DEVICES).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: (){
                     // categoryCubit.setCategory(device);
                      Navigator.pop(context,'$device');
                    },
                    child: Text('$device',style: TextStyle(color: black,fontSize: 18),)),
              );
            })
          ],
        );
        break;
      case 7:
        return Column(
          children: [
            ...(Utils.PERSONAL_ACCESSORIES).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: (){
                     // categoryCubit.setCategory(device);
                      Navigator.pop(context,'$device');
                    },
                    child: Text('$device',style: TextStyle(color: black,fontSize: 18),)),
              );
            })
          ],
        );
        break;
      case 8:
        return Column(
          children: [
            ...(Utils.CLOTHES).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: (){
                     // categoryCubit.setCategory(device);
                      Navigator.pop(context,'$device');
                    },
                    child: Text('$device',style: TextStyle(color: black,fontSize: 18),)),
              );
            })
          ],
        );
        break;
      case 9:
        return Column(
          children: [
            ...(Utils.HOUSE_LIST).map((device) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: (){
                    //  categoryCubit.setCategory(device);
                      Navigator.pop(context,'$device');
                    },
                    child: Text('$device',style: TextStyle(color: black,fontSize: 18),)),
              );
            })
          ],
        );
        break;
        default: return const SizedBox();
    }
 }
}
