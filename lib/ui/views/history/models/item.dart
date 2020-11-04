class Item {
  final int id;
  final String label;
  final String type;
  final String hintText;
  final bool lastItem;

  const Item({this.id, this.label, this.type, this.hintText, this.lastItem});

  factory Item.fromJson(Map<String, dynamic> item) {
    bool lastItem = item['lastItem'] ?? false;
    return Item(
        id: item['id'],
        label: item['label'],
        type: item['type'],
        hintText: item['hintText'],
        lastItem: lastItem);
  }
}
