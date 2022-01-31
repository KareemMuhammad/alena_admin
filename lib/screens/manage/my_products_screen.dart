import 'package:alena_admin/database/products/product_bloc.dart';
import 'package:alena_admin/database/products/product_state.dart';
import 'package:alena_admin/models/product.dart';
import 'package:alena_admin/utils/shared.dart';
import 'package:alena_admin/utils/shared_widgets.dart';
import 'package:alena_admin/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Product> searchedForProducts;
  List<Product> allProducts;
  bool _isSearching = false;
  final TextEditingController _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: TextField(
        controller: _searchTextController,
        cursorColor: Colors.grey[700],
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج معين',
          border: InputBorder.none,
          hintStyle: TextStyle(color: black, fontSize: 16),
        ),
        style: TextStyle(color: black, fontSize: 18),
        onChanged: (searchedProduct) {
          addSearchedFOrItemsToSearchedList(searchedProduct);
        },
      ),
    );
  }

  void addSearchedFOrItemsToSearchedList(String searchedProduct) {
    searchedForProducts = allProducts.where((product) =>
        product.deviceName.toLowerCase().contains(searchedProduct)).toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear, color: black),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(
            Icons.search,
            color: black,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductCubit>(context).loadAdminProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductCubit productCubit = BlocProvider.of<ProductCubit>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        centerTitle: true,
          leading: _isSearching
              ? BackButton(
            color: black,
          )
              : GestureDetector(
                 onTap: (){
                  Navigator.pop(context);
                  },
                child: Icon(Icons.arrow_back, color: black,)),
          title: _isSearching ? _buildSearchField() : Text("قائمة منتجاتى", style: TextStyle(color: black,fontSize: 20,fontFamily: 'AA-GALAXY'),),
          actions: _buildAppBarActions(),
     ),
      backgroundColor: white,
      body: BlocConsumer<ProductCubit,ProductState>(
        listener: (BuildContext context, state) {
            if(state is ProductDeleted){
              productCubit.loadAdminProducts();
            }else if(state is ProductUpdated){
              productCubit.loadAdminProducts();
            }
        },
        builder: (BuildContext context, state) {
          if(state is ProductInitial){
            return const SizedBox();
          }else if(state is ProductLoading){
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (ctx,index){
                  return loadProductShimmer();
                });
          } else if(state is ProductLoaded) {
             allProducts = state.products;
            return allProducts.isEmpty?
            Center(child: Text('قائمة منتجاتك فارغة', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),)
            :ListView.builder(
              itemCount: _searchTextController.text.isEmpty
                  ? allProducts.length : searchedForProducts.length,
              itemBuilder: (BuildContext context, int index) {
                 return Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Card(
                     elevation: 4,
                     color: white,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     child: ProductWidget(product: _searchTextController.text.isEmpty
                         ? allProducts[index] : searchedForProducts[index],productCubit: productCubit,),
                   ),
                 );
              },
            );
          }else if(state is ProductLoadError){
            return Center(child: Text('حدث خطأ فى جلب البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else if(state is ProductDeleteError){
            return Center(child: Text('حدث خطأ فى حذف البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else if(state is ProductNotUpdated){
            return Center(child: Text('حدث خطأ فى تعديل البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 25, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else{
            return Container();
          }
        },
      ),
    );
  }
}
