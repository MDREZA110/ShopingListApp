import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummydata.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: const Text(
          "Your Grocery",
          style: TextStyle(fontSize: 17),
        ),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: ListView(
          padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
          children: [
            for (final groceryItem in groceryItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 20,
                      child: ColoredBox(
                        color: groceryItem.category.color,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Text(groceryItem.name),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(groceryItem.quantity.toString())
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ]),
    );
  }
}
