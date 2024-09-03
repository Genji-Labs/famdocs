import 'package:famdocs/database/family_database_helper.dart';
import 'package:famdocs/models/family.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadFamiliesBlocDB extends Cubit<List<Family>?>{
  LoadFamiliesBlocDB(super.initialState){
    load();
  }

  void load() async{
    try{
      FamilyDatabaseHelper familyDatabaseHelper = FamilyDatabaseHelper(1);
      emit(await familyDatabaseHelper.getAllFamilies());
    }catch(e){
      emit(null);
    }
  }
}