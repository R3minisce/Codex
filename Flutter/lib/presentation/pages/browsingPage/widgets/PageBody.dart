import 'package:codex/presentation/blocs/EditCubit.dart';
import 'package:codex/presentation/pages/browsingPage/widgets/BodyGridView.dart';
import 'package:codex/presentation/pages/browsingPage/widgets/BodyHeader.dart';
import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/PageFooterIndicator.dart';
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
    return BlocProvider<EditCubit>(
      create: (context) => EditCubit(),
      child: ProviderScope(
        child: Padding(
          padding: getSize(context)
              ? EdgeInsets.all(16.0)
              : EdgeInsets.symmetric(vertical: 16.0, horizontal: 160.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<EditCubit, bool>(builder: (context, opened) {
                return BodyHeader(isEdit: opened);
              }),
              //BodyHeader(isEdit: isEdit),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: SearchBar(
                  color: lightBlack,
                  hintLabel: "search",
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              BlocBuilder<EditCubit, bool>(builder: (context, opened) {
                return BodyGridView(isEdit: opened);
              }),
              //BodyGridView(isEdit: isEdit),
              SizedBox(height: 16.0),
              //PageFooterIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
