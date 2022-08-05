// @dart=2.9

import 'dart:ffi';

class TopicWord {
  int id;
  int word_id;
  int topic_id;
  Float weight;
  Float percent;

  TopicWord({
    this.id,
    this.word_id,
    this.topic_id,
    this.weight,
    this.percent,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word_id': word_id,
        'topic_id': topic_id,
        'weight': weight,
        'percent': percent,
      };

  fromJson(dynamic o) {
    id = o['id'];
    word_id = o['word_id'];
    topic_id = o['topic_id'];
    weight = o['weight'];
    percent = o['percent'];
  }
}
