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
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-6bebd-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later';
      });
    }

    if (response.body == 'null') {
      //! Alert   firebase return String 'null' when there is no data in data base
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(response.body);

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
      _isLoading = false;
    });
  }

  void addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    //  DELETE REQUEST ->
    final url = Uri.https('flutter-prep-6bebd-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);
    //     <-  DELETE REQUEST

    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("No item added yet"));

    if (_isLoading) {
      content = Center(
          child: CircularProgressIndicator(
        color: Colors.amber,
      ));
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
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
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

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
      body: content,
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
