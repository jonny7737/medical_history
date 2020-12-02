import 'package:medical_history/ui/views/history/models/item.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Category {
  final int id;
  final String name;
  final String title;
  final String type;
  final List<Item> items;

  Category({this.id, this.name, this.title, this.type, this.items});

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        title = json['title'],
        type = json['type'],
        items = parseItems(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'items': items,
      };

  static List<Item> parseItems(parsedJson) {
    int categoryID = parsedJson['id'];
    var list = parsedJson['items'] as List;
    List<Item> itemList = list.map((data) => Item.fromJson(data, categoryID)).toList();
    return itemList;
  }
}
