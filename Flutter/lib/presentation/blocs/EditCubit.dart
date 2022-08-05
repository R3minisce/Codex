import 'package:flutter_bloc/flutter_bloc.dart';

class EditCubit extends Cubit<bool> {
  EditCubit() : super(false);

  void toogle() => emit(!state);
}
