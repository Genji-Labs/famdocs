import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldState{
  final String message;
  final bool error;
  bool? showLoader;
  TextFieldState(this.error,this.message,[this.showLoader]);
}

class PhoneTextFieldValidatorBloc extends Cubit<TextFieldState>{
  PhoneTextFieldValidatorBloc(super.initialState);

  void check(String text){
    if(text.trim().isEmpty){ emit(TextFieldState(true, "Required field")); }
    else if(text.trim().length!=10) { emit(TextFieldState(true, "Invalid phone number")); }
    else { emit(TextFieldState(false, "")); }
  }

  void showLoader() => emit(TextFieldState(false, "",true));

}