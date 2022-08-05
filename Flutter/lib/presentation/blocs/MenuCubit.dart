import 'package:flutter_bloc/flutter_bloc.dart';

class MenuCubit extends Cubit<bool> {
  MenuCubit() : super(false);

  void toogle() => emit(!state);
}
