import 'package:famdocs/repositories/profile_screen/profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';

class ProfilePrefsBloc extends Cubit<User?>{
  final ProfileRepository profileRepository;
  ProfilePrefsBloc(super.initialState,this.profileRepository){
    loadUser();
  }

  void loadUser() async{
    try{
      emit(await profileRepository.getUserFromPrefs());
    }catch(e){
      if(kDebugMode) print(e);
      emit(null);
    }
  }
}