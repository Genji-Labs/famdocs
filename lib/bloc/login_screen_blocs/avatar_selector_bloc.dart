import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarSelectorBloc extends Cubit<int>{
  AvatarSelectorBloc(super.initialState);

  void updateSelection(int index) => emit(index);
}