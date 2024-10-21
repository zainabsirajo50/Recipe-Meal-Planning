import 'package:flutter/material.dart';
import 'package:recipe_meal_planning_app/screens/favorites_screen.dart';
import '../database_helper.dart';
import 'grocery_list_screen.dart';
import 'meal_planning_screen.dart';


final dbHelper = DatabaseHelper();

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
                  image: NetworkImage(
                      'https://t4.ftcdn.net/jpg/05/38/59/29/240_F_538592931_FMXRupHWHH6lUnXgWcaJZuhO3gMc0B7k.jpg'), // Add your recipe image here
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
                    List<String> ingredientList = ingredients
                        .split(','); // Assuming ingredients are comma-separated
                    // Navigate to Grocery List Screen with ingredients
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroceryListScreen(ingredients: ingredientList),
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
                  onPressed: () async {
                    _showMealPlanDialog(context); // Call meal plan selection dialog                   
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
                onPressed: () async {
                  // Insert recipe name into favorites database
                  try {
                    await dbHelper.insertFavoriteRecipe({
                      'name': recipeName, // Insert recipe name
                    });

                    // Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('$recipeName added to favorites!'),
                    ));

                     // Navigate to the Favorites Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoriteRecipesScreen()), // Navigate to the favorites screen
                    );
                  } catch (e) {
                    // Show an error message in case of failure
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error adding to favorites: $e'),
                    ));
                  }
                },
                icon: Icon(Icons.favorite),
                label: Text("Add to Favorites"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
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
  void _showMealPlanDialog(BuildContext context) {
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Day for $recipeName'),
        content: SingleChildScrollView(
          child: ListBody(
            children: days.map((day) {
              return ListTile(
                title: Text(day),
                onTap: () async {
                  try {
                    await dbHelper.insertMealPlan(recipeName, day); // Insert into meal plan table
                    Navigator.of(context).pop(); // Close the dialog

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('$recipeName added to meal plan for $day!'),                   
                    ));

                      // Navigate to the Favorites Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealPlanningScreen()), // Navigate to the favorites screen
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error saving meal plan: $e'),
                    ));
                  }
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
}
