import 'package:codex/presentation/pages/dashboardPage/widgets/BodyGridview.dart';
import 'package:codex/presentation/pages/dashboardPage/widgets/BodyHeader.dart';
import 'package:codex/presentation/pages/dashboardPage/widgets/BodyInfo.dart';
import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyHeader(),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: BodyInfo(),
          ),
          SizedBox(height: 32.0),
          BodyGridView(),
          SizedBox(height: 32.0),
          BodyGridView(),
        ],
      ),
    );
  }
}
