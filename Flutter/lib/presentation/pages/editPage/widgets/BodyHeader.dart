import 'package:codex/presentation/pages/cardPage/widgets/EditArguments.dart';
import 'package:codex/presentation/pages/editPage/widgets/FilterButton.dart';
import 'package:codex/providers.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodyHeader extends StatelessWidget {
  EditArguments args;

  BodyHeader({Key key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEdit = args.corpus.name != '' ? true : false;

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
            FilterButton(),
            Consumer(
              builder: (context, watch, _) {
                final search = watch(corpusNameProvider).state.toLowerCase();

                return IconButton(
                  onPressed: () {
                    if (isEdit) {
                      String name = search != "" ? search : args.corpus.name;
                      updateCorpus(name, args.corpus.id);
                    } else {
                      createCorpus(search);
                    }

                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(Icons.check),
                  color: Colors.green,
                  iconSize: 30,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
