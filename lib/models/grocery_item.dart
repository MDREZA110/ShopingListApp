import 'package:shopping_list/models/category.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.category,
      required this.quantity});

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
