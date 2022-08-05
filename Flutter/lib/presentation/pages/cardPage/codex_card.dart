import 'package:codex/presentation/blocs/LegendCubit.dart';
import 'package:codex/presentation/blocs/MenuCubit.dart';
import 'package:codex/presentation/pages/cardPage/widgets/PageBody.dart';
import 'package:codex/presentation/widgets/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LegendCubit>(
        create: (context) => LegendCubit(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                PageBody(),
              ],
            ),
          ),
        ));
  }
}
