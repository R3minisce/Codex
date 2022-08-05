import 'package:codex/data/models/Topic.dart';
import 'package:codex/presentation/pages/topicCardPage/widgets/BodyHeader.dart';
import 'package:codex/presentation/pages/topicCardPage/widgets/BodyInfo.dart';

import 'package:codex/services.dart';
import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  final bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    Topic topic = ModalRoute.of(context).settings.arguments as Topic;
    return Padding(
      padding: getSize(context)
          ? EdgeInsets.all(16.0)
          : EdgeInsets.symmetric(vertical: 16.0, horizontal: 160.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyHeader(isEdit: isEdit, topic: topic),
          SizedBox(height: 8.0),
          BodyInfo(topic: topic),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
