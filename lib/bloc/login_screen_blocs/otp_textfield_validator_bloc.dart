import 'package:flutter_bloc/flutter_bloc.dart';


//false if not valid
//true if valid
class OtpTextFieldValidatorBloc extends Cubit<bool>{
  OtpTextFieldValidatorBloc(super.initialState);

  void check(String text){
    try{
      if(text.trim().isEmpty || text.trim().length!=6) throw "hehe";
      int.parse(text);
      emit(true);
    }catch(e) {
      emit(false);
    }
  }
}