import 'package:codex/presentation/pages/loginPage/widgets/actionBar.dart';
import 'package:codex/presentation/styles.dart';
import 'package:flutter/material.dart';

class ActionBarColumn extends StatelessWidget {
  const ActionBarColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.0),
        ActionBar(
          label: "Login",
          color: Colors.grey.shade300,
          textColor: lightBlack,
        ),
        SizedBox(height: 16.0),
        ActionBar(
          label: "Register",
          color: lightBlack,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
