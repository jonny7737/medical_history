import 'package:medical_history/ui/views/history/models/category.dart';

class CategoriesList {
  final List<Category> categories;

  CategoriesList({
    this.categories,
  });

  factory CategoriesList.fromJson(List<dynamic> parsedJson) {
    List<Category> categories = List<Category>();
    categories = parsedJson.map((i) => Category.fromJson(i)).toList();

    return CategoriesList(categories: categories);
  }
}
