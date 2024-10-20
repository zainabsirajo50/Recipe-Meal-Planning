import 'package:flutter/material.dart';
import '../database_helper.dart';

final dbHelper = DatabaseHelper();

class FavoriteRecipesScreen extends StatefulWidget {
  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  List<String> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteRecipes();
  }

  void _fetchFavoriteRecipes() async {
    try {
      final allRows = await dbHelper.queryAllFavoriteRecipes();
      setState(() {
        favoriteRecipes = allRows.map((recipe) => recipe['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching favorite recipes: $e");
    }
  }

  // Add a favorite recipe
  void _addFavoriteRecipe(String recipeName) async {
    if (recipeName.isNotEmpty) {
      try {
        await dbHelper.insertFavoriteRecipe({'name': recipeName});
        _fetchFavoriteRecipes(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error adding recipe: $e")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter a recipe name")));
    }
  }

  // Clear all favorite recipes
  void _deleteAllFavorites() async {
    try {
      await dbHelper.deleteAllFavoriteRecipes();
      setState(() {
        favoriteRecipes.clear(); // Clear the local list
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All favorites deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error deleting favorites: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController favoriteController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Recipes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: favoriteController,
              decoration: InputDecoration(
                labelText: "Add Favorite Recipe",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addFavoriteRecipe(favoriteController.text);
                    favoriteController.clear(); // Clear input field after adding
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _deleteAllFavorites, // Clear all favorites
            child: Text("Delete All Favorites"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteRecipes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}