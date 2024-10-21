import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart' as detail; // Use 'as' for prefix

class RecipeSearchResultsScreen extends StatefulWidget {
  final String query;

  RecipeSearchResultsScreen({required this.query});

  @override
  _RecipeSearchResultsScreenState createState() =>
      _RecipeSearchResultsScreenState();
}

class _RecipeSearchResultsScreenState extends State<RecipeSearchResultsScreen> {
  // Sample list of recipes
  List<String> allRecipes = [
    'Vegan Salad',
    'Gluten-Free Pancakes',
    'Vegetarian Chili',
    'Chocolate Cake',
    'Recipe 1',
    'Recipe 2',
  ];

  // List of dietary filters
  List<String> filters = ['All', 'Vegan', 'Gluten-Free', 'Vegetarian'];
  String selectedFilter = 'All';

  // This will hold the filtered recipes based on the query
  late List<String> filteredRecipes;

  // Controller for the search input
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial search query to what was passed in
    searchController.text = widget.query;
    // Initially, filter recipes based on the query
    _filterRecipes();
  }

  void _filterRecipes() {
    setState(() {
      filteredRecipes = allRecipes.where((recipe) {
        // Check if the recipe name contains the search query
        bool matchesQuery =
            recipe.toLowerCase().contains(searchController.text.toLowerCase());

        // Check for dietary filter
        if (selectedFilter == 'All') {
          return matchesQuery;
        } else if (selectedFilter == 'Vegan') {
          return matchesQuery && recipe.contains('Vegan');
        } else if (selectedFilter == 'Gluten-Free') {
          return matchesQuery && recipe.contains('Gluten-Free');
        } else if (selectedFilter == 'Vegetarian') {
          return matchesQuery && recipe.contains('Vegetarian');
        }
        return false; // No match
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (value) {
            _filterRecipes(); // Re-filter recipes as the search query changes
          },
        ),
        backgroundColor: Colors.purple[200],
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              _filterRecipes(); // Clear search and refresh the list
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newFilter) {
                setState(() {
                  selectedFilter = newFilter!;
                  _filterRecipes(); // Re-filter when the selected filter changes
                });
              },
              items: filters.map<DropdownMenuItem<String>>((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
            ),
          ),
          // Recipe List/GridView
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: filteredRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the Recipe Detail Screen on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detail.RecipeDetailScreen(
                          recipeName: filteredRecipes[index],
                          ingredients: 'Sample ingredients...',
                          steps: 'Sample steps...',
                          nutritionInfo: 'Sample nutrition...',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        filteredRecipes[index],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
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
