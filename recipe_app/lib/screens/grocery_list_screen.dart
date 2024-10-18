import 'package:flutter/material.dart';

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<String> groceryItems = ['Tomatoes', 'Pasta', 'Olive Oil'];
  List<bool> checkedItems = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(groceryItems[index]),
                  value: checkedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedItems[index] = value!;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                groceryItems.addAll(['Onions', 'Garlic', 'Spinach']);
                checkedItems.addAll([false, false, false]);
              });
            },
            child: Text('Add All to List'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Grocery List Updated')),
              );
            },
            child: Text('Save Grocery List'),
          ),
        ],
      ),
    );
  }
}
