class Item {
  final int id;
  final String label;
  final String type;

  Item({this.id, this.label, this.type});

  factory Item.fromJson(Map<String, dynamic> item) {
    return Item(id: item['id'], label: item['label'], type: item['type']);
  }
}
