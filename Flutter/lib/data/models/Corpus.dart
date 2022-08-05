class Corpus {
  int id;
  String name;
  int nbFile;
  int best_topic;
  bool is_selected;

  Corpus({
    this.id = 0,
    this.name = '',
    this.nbFile = 0,
    this.best_topic = 0,
    this.is_selected = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nbFile': nbFile,
        'best_topic': best_topic,
        'is_selected': is_selected,
      };

  fromJson(dynamic o) {
    id = o['id'];
    name = o['name'];
    nbFile = o['nbFile'];
    best_topic = o['best_topic'];
    is_selected = o['is_selected'];
  }
}
