import 'package:flutter_bloc/flutter_bloc.dart';

class ExpandFamiliesCubit extends Cubit<bool>{
  bool currState = false;
  ExpandFamiliesCubit(super.initialState);

  void toggle(){
    currState = !currState;
    emit(currState);
  }
}