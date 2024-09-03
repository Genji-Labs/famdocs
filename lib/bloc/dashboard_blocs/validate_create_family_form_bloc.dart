import 'package:flutter_bloc/flutter_bloc.dart';


class CreateFamilyFormState{
  final bool error;
  final List<String> messages;
  CreateFamilyFormState(this.error,this.messages);
}

class ValidateCreateFamilyFormBloc extends Cubit<CreateFamilyFormState>{
  ValidateCreateFamilyFormBloc(super.initialState);

  void validate(String name,String password,String confirmPassword){
    List<String> errors = ["","",""];
    bool error = false;
    if(name.trim().isEmpty) {
      error = true;
      errors[0] = "Required Field";
    }
    if(password.trim().isEmpty){
      error = true;
      errors[1] = "Required Field";
    }
    if(confirmPassword.trim().isEmpty){
      error = true;
      errors[2] = "Required Field";
    }
    if(confirmPassword!=password){
      error = true;
      errors[2] = "Passwords do not match";
    }
    emit(CreateFamilyFormState(error, errors));
  }
}