import 'package:flutter/material.dart';

class MealPlanningScreen extends StatefulWidget {
  @override
  _MealPlanningScreenState createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  Map<String, String> mealPlan = {
    'Monday': '',
    'Tuesday': '',
    'Wednesday': '',
    'Thursday': '',
    'Friday': '',
    'Saturday': '',
    'Sunday': '',
  };

  final List<String> recipes = [
    'Vegan Tacos',
    'Gluten-Free Pancakes',
    'Chicken Alfredo',
    'Vegan Stir Fry',
    'Gluten-Free Brownies',
  ];

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
                  onTap: () {
                    setState(() {
                      mealPlan[day] = recipe;
                    });
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
}
