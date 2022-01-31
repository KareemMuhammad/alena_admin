import 'package:alena_admin/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository{
  static const PRODUCTS_COLLECTION = "Products";
  static const WAITING_PRODUCTS_COLLECTION = "Waiting Products";

  final _productsCollection = FirebaseFirestore.instance.collection(ProductRepository.PRODUCTS_COLLECTION);
  final _waitingCollection = FirebaseFirestore.instance.collection(ProductRepository.WAITING_PRODUCTS_COLLECTION);

  Future<bool> saveProductToDb(Map<String,dynamic> productMap,String id)async{
    try {
      await _productsCollection.doc(id).set(productMap);
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }
  }

  Future<bool> saveProductToWaitingDb(Map<String,dynamic> productMap,String id)async{
    try {
      await _waitingCollection.doc(id).set(productMap);
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }
  }

  Future<List<Product>> getAllMyProducts(String id)async{
    QuerySnapshot snapshot = await _productsCollection.where(Product.VENDOR_ID, isEqualTo: id).orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<List<Product>> getAllVendorWaitingProducts(String id)async{
    QuerySnapshot snapshot = await _waitingCollection.where(Product.VENDOR_ID, isEqualTo: id).orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<List<Product>> getAllWaitingProducts()async{
    QuerySnapshot snapshot = await _waitingCollection.orderBy(Product.DATE,descending: true).get()
        .catchError((e) {
      print(e.toString());
    });
    return snapshot.docs.map((doc) {
      return Product.fromSnapshot(doc);
    }).toList();
  }

  Future<bool> updateProductInfo(Product product,String id)async{
    try {
      await _productsCollection.doc(id).update(product.toMap());
      return true;
    }catch (e){
      print(e.toString());
      return false;
    }
  }

  Future deleteProduct(String id)async{
    await _productsCollection.doc(id).delete();
  }

  Future removeProductFromWaiting(String id)async{
    await _waitingCollection.doc(id).delete();
  }

}