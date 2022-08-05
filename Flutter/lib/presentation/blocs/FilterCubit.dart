import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<bool> {
  FilterCubit() : super(false);

  void toogle() => emit(!state);
}
