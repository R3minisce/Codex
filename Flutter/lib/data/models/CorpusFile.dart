// @dart=2.9

class CorpusFile {
  int id;
  int corpus_id;
  int file_id;

  CorpusFile({
    this.id,
    this.corpus_id,
    this.file_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'corpus_id': corpus_id,
        'file_id': file_id,
      };

  fromJson(dynamic o) {
    id = o['id'];
    corpus_id = o['corpus_id'];
    file_id = o['file_id'];
  }
}
