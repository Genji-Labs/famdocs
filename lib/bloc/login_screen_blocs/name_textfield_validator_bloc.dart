import 'package:famdocs/bloc/login_screen_blocs/phone_textfield_validator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NameTextFieldValidatorBloc extends Cubit<TextFieldState>{
  NameTextFieldValidatorBloc(super.initialState);

  void check(String text){
    if(text.trim().isEmpty){ emit(TextFieldState(true, "Required field")); }
    else { emit(TextFieldState(false, "")); }
  }

}