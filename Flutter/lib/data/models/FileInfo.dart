class FileInfo {
  String creationTime;
  String language;
  int nbPages;
  int id;
  String title;
  var words;
  var dominant_topics;
  bool is_selected;
  var corpuses;

  FileInfo({
    this.dominant_topics,
    this.creationTime,
    this.language,
    this.nbPages,
    this.title,
    this.corpuses,
    this.words,
    this.is_selected,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'creationTime': creationTime,
        'language': language,
        'nbPages': nbPages,
        'title': title,
        'words': words,
        'corpuses': corpuses,
        'dominant_topics': dominant_topics,
        'is_selected': is_selected,
        'id': id,
      };

  fromJson(dynamic o) {
    creationTime = o['creationTime'];
    language = o['language'];
    nbPages = o['nbPages'];
    title = o['title'];
    dominant_topics = o['dominant_topics'];
    words = o['words'];
    corpuses = o['corpuses'];
    is_selected = o['is_selected'];
    id = o['id'];
  }
}
