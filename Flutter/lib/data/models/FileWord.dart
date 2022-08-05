// @dart=2.9

class FileWord {
  int id;
  int file_id;
  int word_id;

  FileWord({
    this.id,
    this.file_id,
    this.word_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_id': file_id,
        'word_id': word_id,
      };

  fromJson(dynamic o) {
    id = o['id'];
    file_id = o['file_id'];
    word_id = o['word_id'];
  }
}
