class YearFileInfo {
  int file_id;
  int topic_id;
  int parent_id;
  double percent;
  double weight;
  String title;
  String datetime;
  double weight_in_topic;

  YearFileInfo({
    this.file_id,
    this.topic_id,
    this.title,
    this.datetime,
    this.percent,
    this.weight,
    this.parent_id,
    this.weight_in_topic,
  });

  Map<String, dynamic> toJson() => {
        'file_id': file_id,
        'topic_id': topic_id,
        'percent': percent,
        'weight': weight,
        'parent_id': parent_id,
        'title': title,
        'weight_in_topic': weight_in_topic,
        'datetime': datetime,
      };

  fromJson(dynamic o) {
    file_id = o['file_id'];
    topic_id = o['topic_id'];
    title = o['title'];
    weight = o['weight'];
    parent_id = o['parent_id'];
    percent = o['percent'];
    weight_in_topic = o['weight_in_topic'];
    datetime = o['datetime'];
  }
}
