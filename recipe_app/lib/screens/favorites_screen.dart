import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';
import '../database_helper.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteRecipes = [
    'Vegan Tacos',
    'Gluten-Free Brownies',
    // Add more favorite recipes here
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteRecipes[index]),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/recipe-detail',
                arguments: favoriteRecipes[index],
              );
            },
          );
        },
      ),
    );
  }
}
