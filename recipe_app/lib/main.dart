import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'database_helper.dart';
import 'package:recipe_meal_planning_app/screens/favorites_screen.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  final dbHelper = DatabaseHelper();
  await dbHelper.init(); // Initialize the database
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Set HomeScreen as the home widget
    );
  }
}
