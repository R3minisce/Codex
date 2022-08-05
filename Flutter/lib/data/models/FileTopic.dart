class FileTopic {
  int id;
  int file_id;
  int topic_id;
  double file_weight_in_topic;
  String creationTime;
  String language;
  int nbPages;
  String title;
  List<String> words;

  FileTopic({
    this.id,
    this.file_id,
    this.topic_id,
    this.file_weight_in_topic,
    this.creationTime,
    this.language,
    this.nbPages,
    this.title,
    this.words,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_id': file_id,
        'topic_id': topic_id,
        'file_weight_in_topic': file_weight_in_topic,
        'creationTime': creationTime,
        'language': language,
        'nbPages': nbPages,
        'title': title,
        'words': words,
      };

  fromJson(dynamic o) {
    id = o['id'];
    file_id = o['file_id'];
    topic_id = o['topic_id'];
    file_weight_in_topic = o['file_weight_in_topic'];
    creationTime = o['creationTime'];
    language = o['language'];
    nbPages = o['nbPages'];
    title = o['title'];
    words = o['words'];
  }
}
