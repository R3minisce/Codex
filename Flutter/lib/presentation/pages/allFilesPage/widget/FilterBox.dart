import 'package:codex/presentation/charts/charts.dart';
import 'package:codex/presentation/widgets/shadowBorder.dart';
import 'package:flutter/material.dart';
import 'package:codex/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterBox extends StatelessWidget {
  const FilterBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 140,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterField(
                    icon: Icons.language,
                    provider: langSearchProvider,
                    color: colorTheme[1],
                    hint: "language"),
                FilterField(
                    icon: Icons.description,
                    provider: topicSearchProvider,
                    color: colorTheme[2],
                    hint: "topic id"),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterField(
                    icon: Icons.calendar_today,
                    provider: yearSearchProvider,
                    color: colorTheme[3],
                    hint: "time"),
                FilterField(
                    icon: Icons.spellcheck,
                    provider: wordSearchProvider,
                    color: colorTheme[4],
                    hint: "word"),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterField(
                    icon: Icons.topic,
                    provider: corpusSearchProvider,
                    color: colorTheme[5],
                    hint: "corpus id"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterField extends StatelessWidget {
  var icon;
  var provider;
  var color;
  var hint;

  FilterField({
    Key key,
    this.icon,
    this.provider,
    this.color,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 40,
      width: 130,
      decoration: ShadowBorder(32, 32, color),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (String data) {
                context.read(provider).state = data;
                print(data);
              },
            ),
          ),
        ],
      ),
    );
  }
}
