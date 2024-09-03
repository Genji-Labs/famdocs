import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Cubit<ThemeMode>{
  ThemeBloc(super.initialState);

  void switchTo(ThemeMode mode){
    emit(mode);
  }

}