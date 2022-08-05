import 'package:codex/presentation/blocs/FilterCubit.dart';
import 'package:codex/presentation/pages/allFilesPage/widget/FilterBox.dart';
import 'package:codex/presentation/pages/cardPage/widgets/EditArguments.dart';
import 'package:codex/presentation/pages/editPage/widgets/BodyGridview.dart';
import 'package:codex/presentation/pages/editPage/widgets/BodyHeader.dart';
import 'package:codex/presentation/pages/editPage/widgets/NameEntry.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditArguments args =
        ModalRoute.of(context).settings.arguments as EditArguments;
    bool isEdit = args.corpus.name != '' ? true : false;

    toogleAllFileSelection(args.fileIDs);

    return BlocProvider<FilterCubit>(
      create: (context) => FilterCubit(),
      child: ProviderScope(
        child: Padding(
          padding: getSize(context)
              ? EdgeInsets.all(16.0)
              : EdgeInsets.symmetric(vertical: 16.0, horizontal: 160.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<FilterCubit, bool>(builder: (context, opened) {
                return BodyHeader(args: args);
              }),
              SizedBox(height: 12),
              NameEntry(isEdit: isEdit, args: args),
              BodyGridView(),
            ],
          ),
        ),
      ),
    );
  }
}
