class Topic {
  int id;
  double weight;
  double percent;
  int parent_id;

  Topic({
    this.id,
    this.weight,
    this.percent,
    this.parent_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'percent': percent,
        'parent_id': parent_id,
      };

  fromJson(dynamic o) {
    id = o['id'];
    weight = o['weight'];
    parent_id = o['parent_id'];
    percent = o['percent'];
  }
}
