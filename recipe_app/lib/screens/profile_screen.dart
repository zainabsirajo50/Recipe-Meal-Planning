import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'recipe_detail_screen.dart';  
import 'meal_planning_screen.dart';  

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'User Name';  // Default values
  String _email = 'example@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 16),
            Text(_userName, style: TextStyle(fontSize: 24)), // Display updated name
            SizedBox(height: 8),
            Text(_email, style: TextStyle(fontSize: 16)),   // Display updated email
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userName: _userName, 
                      email: _email,
                    ),  // Pass current data to edit screen
                  ),
                );

                if (result != null) {
                  setState(() {
                    _userName = result['userName'];  // Update with new data
                    _email = result['email'];
                  });
                }
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('My Recipes'),
              onTap: () {
                // Navigate directly to RecipeDetailScreen with specific recipe details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(
                      recipeName: 'Spaghetti Bolognese',
                      ingredients: 'Spaghetti, Ground Beef, Tomato Sauce',
                      steps: '1. Cook spaghetti.\n2. Brown ground beef.\n3. Mix with sauce.',
                      nutritionInfo: 'Calories: 500, Fat: 20g, Protein: 25g',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.apple),
              title: Text('Dietary Preferences'),
              onTap: () {
                // Navigate to DietaryPreferencesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanningScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Likes'),
              onTap: () {
                // Navigate to FavoritesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
