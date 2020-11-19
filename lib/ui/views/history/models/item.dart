import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Item {
  @JsonKey(toJson: null, includeIfNull: true)
  final int categoryID;
  final int id;
  final String label;
  final String type;
  final String hintText;
  final bool lastItem;
  String value;

  Item({this.id, this.categoryID, this.label, this.type, this.value, this.hintText, this.lastItem});

  void setValue(val) {
    // print(val);
    value = val;
  }

  Item.fromJson(Map<String, dynamic> json, int categoryID)
      : categoryID = categoryID,
        id = json['id'],
        label = json['label'],
        type = json['type'],
        value = json['value'],
        hintText = json['hintText'],
        lastItem = json['lastItem'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      if (value != null && value.isNotEmpty) 'value': value.toString(),
      'hintText': hintText,
      if (lastItem != null) 'lastItem': lastItem,
    };
  }
}
