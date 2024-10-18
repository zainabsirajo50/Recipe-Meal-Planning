import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart' as detail;
import 'recipe_search_results_screen.dart';
import 'profile_screen.dart';  // Ensure this is imported
import '../database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> recipes = [];
  
  // Sample data for "This Week's Meals"
  final List<Map<String, dynamic>> weekMeals = [
    {'day': 'Monday', 'meal': 'Spaghetti'},
    {'day': 'Tuesday', 'meal': 'Grilled Chicken'},
    {'day': 'Wednesday', 'meal': 'Salad'},
    {'day': 'Thursday', 'meal': 'Tacos'},
    {'day': 'Friday', 'meal': 'Pizza'},
    {'day': 'Saturday', 'meal': 'BBQ Ribs'},
    {'day': 'Sunday', 'meal': 'Soup'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() async {
    try {
      final allRows = await DatabaseHelper.instance.queryAll();
      setState(() {
        recipes = allRows;
      });
    } catch (e) {
      print("Error fetching recipes: $e");
    }

    if (recipes.isEmpty) {
      _showInsertDataDialog();
    }
  }

  void _showInsertDataDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController instructionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("No Recipes Found"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Recipe Name"),
              ),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(labelText: "Ingredients"),
              ),
              TextField(
                controller: instructionsController,
                decoration: InputDecoration(labelText: "Instructions"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String name = nameController.text;
                String ingredients = ingredientsController.text;
                String instructions = instructionsController.text;

                if (name.isNotEmpty && ingredients.isNotEmpty && instructions.isNotEmpty) {
                  try {
                    await DatabaseHelper.instance.insert({
                      'name': name,
                      'ingredients': ingredients,
                      'instructions': instructions,
                    });

                    _fetchRecipes();

                    nameController.clear();
                    ingredientsController.clear();
                    instructionsController.clear();

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving recipe: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields")),
                  );
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeSearchResultsScreen(query: ''),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar at the top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for recipes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            
            // Featured Recipes section (Horizontal scrolling)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Featured Recipes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => detail.RecipeDetailScreen(
                              recipeName: recipes[index]['name'],
                              ingredients: recipes[index]['ingredients'],
                              steps: recipes[index]['instructions'],
                              nutritionInfo: 'Sample nutrition info...',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood, size: 50),
                            Text(recipes[index]['name']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // This Week's Meals section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "This Week's Meals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: weekMeals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text(weekMeals[index]['day']),
                  subtitle: Text(weekMeals[index]['meal']),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInsertDataDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
