import 'package:codex/presentation/styles.dart';
import 'package:codex/presentation/widgets/Balls.dart';
import 'package:flutter/material.dart';

class PageFooterIndicator extends StatelessWidget {
  const PageFooterIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Balls(ballColor: Colors.red),
          SizedBox(width: 4.0),
          Balls(ballColor: lightBlack),
          SizedBox(width: 4.0),
          Balls(ballColor: lightBlack),
        ],
      ),
    );
  }
}
