import 'package:codex/presentation/blocs/FilterCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codex/presentation/blocs/MenuCubit.dart';

class RowHeader extends StatefulWidget {
  var data;
  bool isFilter;

  RowHeader({
    Key key,
    this.data,
    this.isFilter,
  }) : super(key: key);

  @override
  _RowHeaderState createState() => _RowHeaderState();
}

class _RowHeaderState extends State<RowHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => context.read<MenuCubit>().toogle(),
          icon: Icon(Icons.menu),
          iconSize: 30,
        ),
        IconButton(
          onPressed: () => context.read<FilterCubit>().toogle(),
          icon: Icon(Icons.filter_alt_outlined),
          iconSize: 30,
        ),
      ],
    );
  }
}
