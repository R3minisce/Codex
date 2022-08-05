import 'package:codex/presentation/pages/cardPage/widgets/EditArguments.dart';
import 'package:codex/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameEntry extends StatelessWidget {
  const NameEntry({
    Key key,
    @required this.isEdit,
    @required this.args,
  }) : super(key: key);

  final bool isEdit;
  final EditArguments args;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 80,
        width: double.maxFinite,
        color: Colors.white,
        child: TextField(
          decoration: InputDecoration(
              hintText: isEdit ? args.corpus.name : "Enter corpus name ..."),
          onChanged: (String data) {
            context.read(corpusNameProvider).state = data;
          },
        ));
  }
}
