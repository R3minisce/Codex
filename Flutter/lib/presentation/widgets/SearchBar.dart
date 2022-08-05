import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:codex/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String search);

class SearchBar extends StatelessWidget {
  final Color color;
  final String hintLabel;
  final Color textColor;

  const SearchBar({
    Key key,
    this.color,
    this.hintLabel,
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
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintLabel,
                      hintStyle: TextStyle(color: textColor.withOpacity(0.75)),
                    ),
                    style: TextStyle(color: textColor),
                    onChanged: (String data) {
                      context.read(searchProvider).state = data;
                      print(data);
                    },
                  ),
                ),
                Icon(
                  Icons.search,
                  color: textColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
