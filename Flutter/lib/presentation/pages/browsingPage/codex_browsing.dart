import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/pages/browsingPage/widgets/PageBody.dart';
import 'package:codex/presentation/widgets/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrowsingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuCubit>(
      create: (_) => MenuCubit(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              PageBody(),
              BlocBuilder<MenuCubit, bool>(builder: (context, opened) {
                if (opened) return Menu();
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
