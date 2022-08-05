import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;

  const ActionBar({
    Key key,
    this.color,
    this.label,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Container(
          decoration: ShadowBorder(32, 32, color),
          width: double.infinity,
          height: 40,
          child: Material(
            type: MaterialType.transparency,
            elevation: 6.0,
            color: Colors.transparent,
            shadowColor: Colors.grey[50],
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              splashColor: Colors.red.withOpacity(0.3),
              onTap: () {
                Navigator.pushNamed(context, '/browsing');
              },
              child: Align(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
