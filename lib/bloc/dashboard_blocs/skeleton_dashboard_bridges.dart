import 'package:famdocs/models/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/family.dart';


class PageDataObject{
  final Pages page;
  Family? family;
  PageDataObject(this.page,[this.family]);
}
class SkeletonToDashboardSwitchPageBloc extends Cubit<PageDataObject>{
  SkeletonToDashboardSwitchPageBloc(super.initialState);

  void switchPage(Pages page,[Family? family]) {
    if(family==null) {emit(PageDataObject(page)); return;}
    emit(PageDataObject(page,family));
  }
}

class DashboardToSkeletonOpenDrawerBloc extends Cubit<int>{
  DashboardToSkeletonOpenDrawerBloc(super.initialState);


  //command is a randomizer doesn't hold any significance just use Random()
  void open(int command) => emit(command);
}