import 'package:codex/data/models/Corpus.dart';
import 'package:codex/presentation/blocs/EditCubit.dart';
import 'package:codex/presentation/blocs/LegendCubit.dart';
import 'package:codex/presentation/pages/cardPage/widgets/BodyHeader.dart';
import 'package:codex/presentation/pages/cardPage/widgets/BodyInfo.dart';
import 'package:codex/presentation/widgets/PageFooterIndicator.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  final bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    Corpus corpus = ModalRoute.of(context).settings.arguments as Corpus;
    return Padding(
      padding: getSize(context)
          ? EdgeInsets.all(16.0)
          : EdgeInsets.symmetric(vertical: 16.0, horizontal: 160.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyHeader(isEdit: isEdit, corpus: corpus),
          SizedBox(height: 8.0),
          BodyInfo(corpus: corpus),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
