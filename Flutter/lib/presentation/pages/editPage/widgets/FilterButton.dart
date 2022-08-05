import 'package:codex/presentation/blocs/FilterCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<FilterCubit>().toogle(),
      icon: Icon(Icons.filter_alt_outlined),
      iconSize: 30,
    );
  }
}
