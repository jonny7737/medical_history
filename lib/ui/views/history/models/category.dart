import 'package:json_annotation/json_annotation.dart';
import 'package:medical_history/ui/views/history/models/item.dart';

@JsonSerializable()
class Category {
  final int id;
  final String name;
  final String title;
  final String type;
  final List<Item> items;
  final List<Item> baseItems;

  Category({this.id, this.name, this.title, this.type, this.items, this.baseItems});

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        title = json['title'],
        type = json['type'],
        items = parseItems(json),
        baseItems = parseBaseItems(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'items': items,
        if (baseItems != null) 'baseItems': baseItems,
      };

  static List<Item> parseItems(parsedJson) {
    int categoryID = parsedJson['id'];
    var list = parsedJson['items'] as List;
    List<Item> itemList = list.map((data) => Item.fromJson(data, categoryID)).toList();
    return itemList;
  }

  static List<Item> parseBaseItems(parsedJson) {
    int categoryID = parsedJson['id'];
    var list = parsedJson['baseItems'] as List;
    List<Item> itemList;
    if (list != null) itemList = list.map((data) => Item.fromJson(data, categoryID)).toList();
    return itemList;
  }
}
