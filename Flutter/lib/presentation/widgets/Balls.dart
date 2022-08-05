import 'package:codex/presentation/styles.dart';
import 'package:flutter/material.dart';

class Balls extends StatelessWidget {
  Balls({
    Key key,
    this.ballColor,
  }) : super(key: key);

  final Color ballColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: new BoxDecoration(
        border: Border.all(color: lightBlack),
        color: ballColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
