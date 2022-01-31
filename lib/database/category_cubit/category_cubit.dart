import 'package:alena_admin/database/category_cubit/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState>{

  CategoryCubit() : super(CategoryInitial());

String category;

  setCategory(String cat){
    this.category = cat;
    if(category != null) {
      emit(CategoryDone(category));
    }else{
      emit(CategoryFailure());
    }
  }

}