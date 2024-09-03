import 'package:famdocs/repositories/login_screen/login_signup_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';

class SignupBlocState{
  final bool success;
  User? user;
  bool? showLoader;
  SignupBlocState(this.success,[this.user]);
}

class SignupBloc extends Cubit<SignupBlocState>{
  SignupBloc(super.initialState);

  void signup(String phone,String token,int avatar,String name) async{
    try{
      LoginSignupRepository repo = LoginSignupRepository();
      User user = await repo.signup(phone, token, avatar, name);
      emit(SignupBlocState(true,user));
    }catch(e){
      emit(SignupBlocState(false));
    }
  }

  void showLoader(){
    SignupBlocState state = SignupBlocState(false);
    state.showLoader = true;
    emit(state);
  }

}