
import 'package:famdocs/bloc/bloc_response.dart';
import 'package:famdocs/exceptions/arbitrary_exception.dart';
import 'package:famdocs/exceptions/custom_exception.dart';
import 'package:famdocs/models/user.dart';
import 'package:famdocs/repositories/profile_screen/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileBlocResponse extends BlocResponse{
  final User? user;
  ProfileBlocResponse(super.exception,this.user);
}

class ProfileBloc extends Cubit<ProfileBlocResponse>{
  ProfileBloc(super.initialState){
    getUser();
  }

  void getUser() async{
    ProfileRepository repo = ProfileRepository();
    User? user;
    CustomException? exception;
    try {
      user = await repo.getUser();
    }catch(e){
      exception = (e is CustomException)?e:ArbitraryException(e.toString(), e.toString());
    }
    emit(ProfileBlocResponse(exception, user));
  }
}