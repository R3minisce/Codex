import 'package:codex/presentation/styles.dart';
import 'package:flutter/material.dart';

BoxDecoration ShadowBorder(double leftRadius, double rightRadius, Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.horizontal(
        left: Radius.circular(leftRadius), right: Radius.circular(rightRadius)),
    boxShadow: [
      BoxShadow(
        color: lightBlack.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}
