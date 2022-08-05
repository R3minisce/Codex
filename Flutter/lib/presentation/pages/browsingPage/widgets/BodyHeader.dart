import 'package:codex/presentation/pages/cardPage/widgets/EditArguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codex/data/models/Corpus.dart';
import 'package:codex/presentation/blocs/EditCubit.dart';
import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/services.dart';

class BodyHeader extends StatefulWidget {
  BodyHeader({Key key, this.isEdit}) : super(key: key);

  // TODO
  final bool isEdit;

  @override
  _BodyHeaderState createState() => _BodyHeaderState();
}

class _BodyHeaderState extends State<BodyHeader> {
  List<Corpus> allCorpus = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Corpus>>(
      future: getAllCorpuses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("[ ERROR : CORPUS FETCH ]");
        }
        if (!snapshot.hasData) {
          return RowHeader(
            isEdit: widget.isEdit,
            data: allCorpus,
            refreshParent: () {},
          );
        } else {
          allCorpus = snapshot.data;
          return RowHeader(
            isEdit: widget.isEdit,
            data: allCorpus,
            refreshParent: () {},
          );
        }
      },
    );
  }
}

class RowHeader extends StatefulWidget {
  var data;
  bool isEdit;
  VoidCallback refreshParent;

  RowHeader({
    Key key,
    this.data,
    this.isEdit,
    this.refreshParent,
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
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (widget.isEdit) {
                  for (var corpus in widget.data) {
                    print(corpus.is_selected);
                    if (corpus.is_selected) deleteCorpus(corpus);
                  }
                }
                context.read<EditCubit>().toogle();
              },
              icon: Icon(
                widget.isEdit ? Icons.delete : Icons.edit,
                color: widget.isEdit ? Colors.red : lightBlack,
              ),
              iconSize: 24,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit',
                    arguments: EditArguments(corpus: Corpus(), fileIDs: []));
              },
              icon: Icon(Icons.add),
              iconSize: 30,
            ),
          ],
        )
      ],
    );
  }
}
