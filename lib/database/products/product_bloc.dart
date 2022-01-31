import 'package:alena_admin/database/products/product_state.dart';
import 'package:alena_admin/database/products/product_repository.dart';
import 'package:alena_admin/models/product.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCubit extends Cubit<ProductState>{
  final ProductRepository productRepo;

  ProductCubit({this.productRepo}) : super(ProductInitial());

  List<Product> _product;
  List<Product> _waitingProduct;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loadAdminProducts()async{
    try {
      emit(ProductLoading());
      _product = await productRepo.getAllMyProducts(_auth.currentUser.uid);
      if(_product != null) {
        emit(ProductLoaded(_product));
      }else{
        emit(ProductLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future loadWaitingProducts()async{
    try {
      emit(ProductLoading());
      _waitingProduct = await productRepo.getAllWaitingProducts();
      if(_waitingProduct != null) {
        emit(ProductLoaded(_waitingProduct));
      }else{
        emit(ProductLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future loadVendorWaitingProducts()async{
    try {
      emit(ProductLoading());
      _waitingProduct = await productRepo.getAllVendorWaitingProducts(_auth.currentUser.uid);
      if(_waitingProduct != null) {
        emit(ProductLoaded(_waitingProduct));
      }else{
        emit(ProductLoadError());
      }
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future addNewProduct(Product product,String id)async{
    try {
      await productRepo.saveProductToDb(product.toMap(), id);
      print('product is added');
      emit(WaitingProductAdded());
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future addProductToWaiting(Product product,String id)async{
    try {
      await productRepo.saveProductToWaitingDb(product.toMap(), id);
      print('wait is added');
      emit(ProductAddedToWait());
    }catch(e){
      print(e.toString());
      emit(ProductLoadError());
    }
  }

  Future deleteProductById(String id)async{
    try {
      await productRepo.deleteProduct(id);
      print('delete product');
      emit(ProductDeleted());
    }catch(e){
      print(e.toString());
      emit(ProductDeleteError());
    }
  }

  Future removeWaitingById(String id)async{
    try {
      await productRepo.removeProductFromWaiting(id);
      print('remove waiting');
      emit(ProductDeleted());
    }catch(e){
      print(e.toString());
      emit(ProductDeleteError());
    }
  }

}