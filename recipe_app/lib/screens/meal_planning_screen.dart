import 'package:flutter/material.dart';
import '../database_helper.dart'; // Import your DatabaseHelper

final dbHelper = DatabaseHelper(); // Initialize DatabaseHelper

class MealPlanningScreen extends StatefulWidget {
  @override
  _MealPlanningScreenState createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  // This is the list of available recipes for selection
  final List<String> recipes = [
    'Vegan Tacos',
    'Gluten-Free Pancakes',
    'Chicken Alfredo',
    'Vegan Stir Fry',
    'Gluten-Free Brownies',
  ];
  
  
  Map<String, String> mealPlan = {
    'Monday': '',
    'Tuesday': '',
    'Wednesday': '',
    'Thursday': '',
    'Friday': '',
    'Saturday': '',
    'Sunday': '',
  };

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  // Load meal plan from the database
  void _loadMealPlan() async {
    Map<String, String> loadedMealPlan = await dbHelper.getMealPlan();
    setState(() {
      mealPlan = loadedMealPlan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mealPlan.length,
              itemBuilder: (context, index) {
                String day = mealPlan.keys.elementAt(index);
                return ListTile(
                  title: Text(day),
                  subtitle: Text(mealPlan[day]!),
                  onTap: () {
                    _showRecipeDialog(day);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDialog(String day) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Recipe for $day'),
          content: SingleChildScrollView(
            child: ListBody(
              children: recipes.map((recipe) {
                return ListTile(
                  title: Text(recipe),
                  onTap: () async {
                    // Insert into meal plan table
                    await dbHelper.insertMealPlan(recipe, day);
                    
                    // Refresh the screen with the updated meal plan
                    _loadMealPlan();

                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _saveMealPlan(String day, String recipe) async {
    try {
      await dbHelper.insertMealPlan(recipe, day); // Pass recipe and day

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$recipe added to meal plan for $day!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving meal plan: $e'),
      ));
    }
  }
}

  

