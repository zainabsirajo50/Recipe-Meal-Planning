import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeName;
  final String ingredients;
  final String steps;
  final String nutritionInfo;

  RecipeDetailScreen({
    required this.recipeName,
    required this.ingredients,
    required this.steps,
    required this.nutritionInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
        backgroundColor: Colors.purple[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/recipe_image.png'), // Add your recipe image here
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Ingredients Section
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(ingredients),
            SizedBox(height: 16),
            // Steps Section
            Text(
              'Steps:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(steps),
            SizedBox(height: 16),
            // Nutrition Info Section
            Text(
              'Nutrition Info:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(nutritionInfo),
            SizedBox(height: 32),
            // Buttons with Icons and Styling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Grocery List Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroceryListScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Add to Grocery List"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Meal Planner Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealPlannerScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text("Add to Meal Plan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Save the recipe to Favorites
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Recipe saved to Favorites!'),
                  ));
                },
                icon: Icon(Icons.favorite),
                label: Text("Save Recipe"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Screens for Grocery List and Meal Planner
class GroceryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery List"),
      ),
      body: Center(child: Text("Grocery List Screen")),
    );
  }
}

class MealPlannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Planner"),
      ),
      body: Center(child: Text("Meal Planner Screen")),
    );
  }
}
