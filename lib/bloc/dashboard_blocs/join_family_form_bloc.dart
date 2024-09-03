import 'package:famdocs/common/resources.dart';
import 'package:famdocs/repositories/family_repository/family_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class JoinFamilyFormState{}

class ValidateState extends JoinFamilyFormState{
  final String codeMessage;
  final bool codeError;
  final String passwordMessage;
  final bool passwordError;
  ValidateState(this.codeError,this.codeMessage,this.passwordError,this.passwordMessage);
}

class SuccessState extends JoinFamilyFormState{}


class JoinFamilyFormBloc extends Cubit<JoinFamilyFormState?>{
  final BuildContext context;
  JoinFamilyFormBloc(super.initialState,this.context);

  void validate(String code,String password){
    bool codeError = false;
    String codeMessage = "";
    bool passwordError = false;
    String passwordMessage = "";
    if(!code.trim().startsWith("FAM") || code.trim().length<4){
      codeError = true;
      codeMessage = "Invalid code";
    }else if(password.trim().isEmpty){
      passwordError = true;
      passwordMessage = "Required field";
    }
    emit(ValidateState(codeError, codeMessage, passwordError, passwordMessage));
  }

  void joinFam(FamilyRepository repo,String joinCode,String password) async{
    Resources.showAppLoader(context);
    try{
      await repo.joinFamily(joinCode,password);
      emit(SuccessState());
    }catch(e){
      print(e);
    }finally{
      Resources.killAppLoader(context);
    }
  }
}