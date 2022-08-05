// @dart=2.9

class Word {
  int id;
  String word;
  double percent;
  double weight;
  int topic_id;
  int word_id;

  Word({
    this.id,
    this.word,
    this.percent,
    this.weight,
    this.topic_id,
    this.word_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'percent': percent,
        'weight': weight,
        'topic_id': topic_id,
        'word_id': word_id,
      };

  fromJson(dynamic o) {
    id = o['id'];
    word = o['word'];
    percent = o['percent'];
    weight = o['weight'];
    topic_id = o['topic_id'];
    word_id = o['word_id'];
  }
}
