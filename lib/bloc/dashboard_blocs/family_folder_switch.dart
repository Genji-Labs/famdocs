import 'package:famdocs/models/family.dart';
import 'package:famdocs/models/folder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FamilySwitch extends Cubit<Family>{
  FamilySwitch(super.initialState);

  void changeFamily(Family fam) => emit(fam);
}

class FolderSwitch extends Cubit<Folder>{
  FolderSwitch(super.initialState);

  void changeFolder(Folder folder){
    emit(folder);
  }
}