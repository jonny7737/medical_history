import 'package:medical_history/ui/views/history/models/item.dart';

class Category {
  final int id;
  final String name;
  final String title;
  final List<Item> items;

  Category({this.id, this.name, this.title, this.items});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
      id: parsedJson['id'],
      name: parsedJson['name'],
      title: parsedJson['title'],
      items: parseItems(parsedJson),
    );
  }

  static List<Item> parseItems(parsedJson) {
    var list = parsedJson['items'] as List;
    List<Item> itemList = list.map((data) => Item.fromJson(data)).toList();
    return itemList;
  }

  String itemsString() {
    String str = '';
    for (var item in items) {
      if (str.length == 0)
        str = item.label;
      else
        str = str + ' : ' + item.label;
    }
    return str;
  }
}
