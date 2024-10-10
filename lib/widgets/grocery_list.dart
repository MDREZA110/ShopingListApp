// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  void loadItem() async {
    final url = Uri.https('flutter-prep-6bebd-default-rtdb.firebaseio.com',
        '/shopping-list.json');

    final response = await http.get(url);

    final Map<String, dynamic> listData = jsonDecode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void addItem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(),
      ),
    );
    loadItem();
  }

  void removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: const Text(
          "Your Grocery",
          style: TextStyle(
            fontSize: 17, /* fontWeight: FontWeight.bold*/
          ),
        ),
        actions: [
          IconButton(
              onPressed: addItem,
              icon: const Icon(Icons.add_circle_outline_rounded))
        ],
      ),
      body: _groceryItems.isEmpty
          ? Center(child: Text("No item added yet"))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) => Dismissible(
                onDismissed: (direction) {
                  removeItem(_groceryItems[index]);
                },
                key: ValueKey(_groceryItems[index].id),
                child: ListTile(
                  leading: SizedBox.square(
                    dimension: 20,
                    child: ColoredBox(
                      color: _groceryItems[index].category.color,
                    ),
                  ),
                  trailing: Text(_groceryItems[index].quantity.toString()),
                  title: Text(_groceryItems[index].name),
                ),
              ),
            ),
    );
  }
}





// ListView(
//           padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
//           children: [
//             for (final groceryItem in groceryItems)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 17),
//                 child: Row(
//                   children: [
//                     SizedBox.square(
//                       dimension: 20,
//                       child: ColoredBox(
//                         color: groceryItem.category.color,
//                       ),
//                     ),
//                     const SizedBox(width: 25),
//                     Text(groceryItem.name),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Text(groceryItem.quantity.toString())
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//           ]),