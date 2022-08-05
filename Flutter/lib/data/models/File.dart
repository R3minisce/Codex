class File {
  int id;
  String title;
  String language;
  String fileType;
  var creationTime;
  int nbPages;
  var body;
  bool is_selected;

  File({
    this.id,
    this.title,
    this.language,
    this.fileType,
    this.creationTime,
    this.nbPages,
    this.body,
    this.is_selected,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'language': language,
        'fileType': fileType,
        'creationTime': creationTime,
        'nbPages': nbPages,
        'body': body,
        'is_selected': is_selected,
      };

  fromJson(dynamic o) {
    id = o['id'];
    title = o['title'];
    language = o['language'];
    fileType = o['fileType'];
    creationTime = o['creationTime'];
    nbPages = o['nbPages'];
    body = o['body'];
    is_selected = o['is_selected'];
  }
}
