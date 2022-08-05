import 'package:codex/presentation/blocs/EditCubit.dart';
import 'package:codex/presentation/blocs/FilterCubit.dart';
import 'package:codex/presentation/pages/allFilesPage/widget/BodyHeader.dart';
import 'package:codex/presentation/pages/allFilesPage/widget/FileListView.dart';
import 'package:codex/presentation/pages/allFilesPage/widget/FilterBox.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/SearchBar.dart';
import 'package:codex/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  final bool isEdit = false;

  @override
  Widget build(BuildContext context) {
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
                return RowHeader(isFilter: opened);
              }),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: SearchBar(
                  color: lightBlack,
                  hintLabel: "search",
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              BlocBuilder<FilterCubit, bool>(builder: (context, opened) {
                if (opened) return FilterBox();
                return Container();
              }),
              SizedBox(height: 16.0),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: ListViewBuilder(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
