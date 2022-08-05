import 'package:flutter/material.dart';

class BodyInfo extends StatelessWidget {
  const BodyInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Azhorr !"),
        Text("Last visite on the 1st May 2021"),
      ],
    );
  }
}
