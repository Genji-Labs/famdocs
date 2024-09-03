import 'package:famdocs/models/user.dart';
import 'package:famdocs/repositories/login_screen/login_signup_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpVerificationState{
  final String message;
  final bool success;
  bool? showLoader;
  User? user;
  OtpVerificationState(this.message,this.success,[this.user]);
}
class OtpVerifierBloc extends Cubit<OtpVerificationState>{
  OtpVerifierBloc(super.initialState);

  void verify(String phone,String otp,String token) async{
    try {
      LoginSignupRepository repo = LoginSignupRepository();
      User user = await repo.login(phone, otp, token);
      emit(OtpVerificationState("Done", true, user));
    }catch(e) {
      if(kDebugMode) print(e);
      emit(OtpVerificationState("Error occurred", false));
    }
  }

  void showLoader(){
    OtpVerificationState state = OtpVerificationState("", false);
    state.showLoader = true;
    emit(state);
  }
}