class Item {
  final int categoryID;
  final int id;
  final String label;
  final String type;
  final String hintText;
  final bool lastItem;

  const Item({this.id, this.categoryID, this.label, this.type, this.hintText, this.lastItem});

  factory Item.fromJson(Map<String, dynamic> item, int categoryID) {
    bool lastItem = item['lastItem'] ?? false;
    return Item(
        id: item['id'],
        categoryID: categoryID,
        label: item['label'],
        type: item['type'],
        hintText: item['hintText'],
        lastItem: lastItem);
  }

  Map<String, dynamic> toJson() => {'id': id, 'category': categoryID, 'label': label};
}
