import 'package:famdocs/common/resources.dart';
import 'package:famdocs/database/family_database_helper.dart';
import 'package:famdocs/database/folder_database_helper.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/repositories/user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadFamiliesBloc extends Cubit<List<Family>>{
  final BuildContext context;
  LoadFamiliesBloc(super.initialState,this.context) {
    loadFamilies();
  }

  void loadFamilies() async{
    await Resources.showAppLoader(context);
    List<Family>? families = List.empty(growable: true);
    try {
      UserRepository userRepository = UserRepository();
      families = await userRepository.getFamilies();
      if(families==null) throw "something";
      FamilyDatabaseHelper familyDB = FamilyDatabaseHelper(1);
      FolderDatabaseHelper folderDB = FolderDatabaseHelper(1);
      for(Family family in families) {
        familyDB.insertFamily(family);
        folderDB.insertFolder(family.rootFolder!);
      }
    }catch(e){
      if(kDebugMode) print(e);
    }finally{
      if(context.mounted) Resources.killAppLoader(context);
      emit(families!);
    }
  }
}