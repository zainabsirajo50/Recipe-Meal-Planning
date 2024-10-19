import 'package:flutter/material.dart';
import '../database_helper.dart';

final dbHelper = DatabaseHelper();

class GroceryListScreen extends StatefulWidget {
  final List<String> ingredients; // Accept a list of ingredients

  GroceryListScreen({Key? key, required this.ingredients}) : super(key: key);

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<String> groceryItems = [];
  final TextEditingController groceryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchGroceryItems();
  }

  void _fetchGroceryItems() async {
    try {
      final allRows = await dbHelper.queryAllGroceryItems();
      setState(() {
        groceryItems = allRows.map((item) => item['item'] as String).toList();
      });
    } catch (e) {
      print("Error fetching grocery items: $e");
    }
  }

  // Add a new grocery item to the database
  void _addGroceryItem() async {
    String newItem = groceryController.text;

    if (newItem.isNotEmpty) {
      try {
        await dbHelper.insertGroceryItem({'item': newItem});
        groceryController.clear(); // Clear the input field
        _fetchGroceryItems(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error adding item: $e")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter an item")));
    }
  }

  // Clear all grocery items from the database and UI
  void _deleteAllGroceryItems() async {
    try {
      await dbHelper
          .deleteAllGroceryItems(); // Implement this method in DatabaseHelper
      setState(() {
        groceryItems.clear(); // Clear the local list
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All items deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error deleting items: $e")));
    }
  }

  // Add all ingredients to grocery list
  void _addAllIngredientsToList() {
    for (String ingredient in widget.ingredients) {
      groceryItems.add(ingredient);
      // Optionally add to the database if you want to persist
      dbHelper.insertGroceryItem({'item': ingredient});
    }
    setState(() {
      // Refresh the list to display added items
      _fetchGroceryItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grocery List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: groceryController,
              decoration: InputDecoration(
                labelText: "Add Grocery Item",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addGroceryItem,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addAllIngredientsToList,
            child: Text("Add All Ingredients to List"),
          ),
          ElevatedButton(
            onPressed: _deleteAllGroceryItems, // Delete All button
            child: Text("Delete All"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(groceryItems[index]),
                  // Add a checkbox for checking off items
                  trailing: Checkbox(
                    value:
                        false, // Implement your logic to manage checked state
                    onChanged: (bool? value) {
                      setState(() {
                        // Manage checked state here
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
