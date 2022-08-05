import 'package:codex/data/models/Topic.dart';
import 'package:codex/presentation/blocs/LegendCubit.dart';
import 'package:codex/presentation/pages/cardPage/widgets/EditArguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codex/data/models/Corpus.dart';
import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/services.dart';

class BodyHeader extends StatelessWidget {
  bool isOpen;

  BodyHeader({Key key, this.isEdit, this.topic}) : super(key: key);

  Topic topic;

  // TODO
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: Icon(Icons.arrow_back),
          iconSize: 30,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<LegendCubit>().toogle(),
              icon: Icon(Icons.info_outline),
              iconSize: 30,
            ),
          ],
        )
      ],
    );
  }
}
