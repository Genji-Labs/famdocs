import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPagerBloc extends Cubit<int>{
  ViewPagerBloc(super.initialState);
  void jumpTo(int page) => emit(page);
}