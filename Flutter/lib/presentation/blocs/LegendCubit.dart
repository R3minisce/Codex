import 'package:flutter_bloc/flutter_bloc.dart';

class LegendCubit extends Cubit<bool> {
  LegendCubit() : super(false);

  void toogle() => emit(!state);
}
