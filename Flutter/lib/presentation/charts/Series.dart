import 'package:codex/data/models/Topic.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class TopicSeries {
  final int topic;
  final int percent;
  final double weight;
  final charts.Color barColor;

  TopicSeries({
    this.topic,
    this.percent,
    this.weight,
    this.barColor,
  });
}

class WordSeries {
  final int id;
  final int topic_id;
  final int word_id;
  final int percent;
  final double weight;
  final String word;
  final charts.Color barColor;

  WordSeries({
    this.id,
    this.topic_id,
    this.word_id,
    this.percent,
    this.weight,
    this.word,
    this.barColor,
  });
}

class YearSeries {
  String datetime;
  int datetime_int;
  int topic_id;
  int nb_file;
  charts.Color barColor;

  YearSeries({
    this.topic_id,
    this.nb_file,
    this.datetime,
    this.datetime_int,
    this.barColor,
  });
}
