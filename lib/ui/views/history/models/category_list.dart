import 'package:medical_history/ui/views/history/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CategoriesList {
  final List<Category> categories;

  CategoriesList({
    this.categories,
  });

  CategoriesList.fromJson(Map<String, dynamic> json) : categories = parseCategories(json);

  Map<String, dynamic> toJson() => {'categories': categories};

  static List<Category> parseCategories(parsedJson) {
    var list = parsedJson['categories'] as List;
    List<Category> categories = list.map((data) => Category.fromJson(data)).toList();
    return categories;
  }
}
