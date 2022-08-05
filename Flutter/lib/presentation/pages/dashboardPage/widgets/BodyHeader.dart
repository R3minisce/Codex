import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyHeader extends StatelessWidget {
  const BodyHeader({
    Key key,
  }) : super(key: key);

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
        Container(
            width: 50,
            height: 50,
            decoration: ShadowBorder(32, 32, Colors.white),
            child: Icon(Icons.person_outline)),
      ],
    );
  }
}
