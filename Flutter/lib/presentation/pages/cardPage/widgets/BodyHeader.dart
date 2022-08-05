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

  BodyHeader({Key key, this.isEdit, this.corpus}) : super(key: key);

  Corpus corpus;

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
            IconButton(
              onPressed: () {
                Future<List<int>> files = getCorpusFilesByCorpus(corpus);
                files.then(
                  (data) => Navigator.pushNamed(
                    context,
                    '/edit',
                    arguments: EditArguments(corpus: corpus, fileIDs: data),
                  ),
                );
              },
              icon: Icon(
                !isEdit ? Icons.edit : Icons.delete,
                color: !isEdit ? lightBlack : Colors.red,
              ),
              iconSize: 24,
            ),
            // IconButton(
            //   onPressed: () {
            //     analyseCorpus(corpus.id);
            //   },
            //   icon: Icon(Icons.model_training),
            //   iconSize: 30,
            // ),
          ],
        )
      ],
    );
  }
}
