import 'package:flutter/material.dart';
import 'package:recipe_meal_planning_app/screens/favorites_screen.dart';
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

class ProfileScreen extends StatelessWidget {
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
            Text('User Name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(), // Navigate to Edit Profile
                  ),
                );
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('My Recipes'),
              onTap: () {
                // Navigate to My Recipes Screen
              },
            ),
            ListTile(
              leading: Icon(Icons.apple),
              title: Text('Dietary Preferences'),
              onTap: () {
                // Navigate to Dietary Preferences Screen
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Likes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteRecipesScreen(), // Navigate to Edit Profile
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
