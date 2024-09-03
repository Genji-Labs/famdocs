import 'package:famdocs/bloc/login_screen_blocs/phone_textfield_validator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderDialogValidatorBloc extends Cubit<TextFieldState>{
  FolderDialogValidatorBloc(super.initialState);

  void check(String folderName){
    if(folderName.trim().isEmpty){
      emit(TextFieldState(true, "Required field"));
      return;
    }
    emit(TextFieldState(false, ""));
  }

  void showLoader(TextFieldState state) {
    state.showLoader = true;
    emit(state);
  }
}