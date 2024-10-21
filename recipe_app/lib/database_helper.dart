import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "recipesDatabase.db";
  static final _databaseVersion = 2;

  static final table = 'recipes';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnIngredients = 'ingredients';
  static final columnInstructions = 'instructions';

  static final groceryTable = 'grocery_list';
  static final columnGroceryId = 'id';
  static final columnItem = 'item';

  static final favoritesTable = 'favorites';
  static final columnFavId = 'id';
  static final columnFavName = 'name';

  static final mealPlanTable = 'meal_plan';
  static final columnMealId = 'id';
  static final columnDay = 'day';
  static final columnRecipe = 'recipe';

  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      await init(); // Initialize the database if it's not yet initialized
    }
    return _db!;
  }

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnIngredients TEXT NOT NULL,
        $columnInstructions TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $groceryTable (
        $columnGroceryId INTEGER PRIMARY KEY,
        $columnItem TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $favoritesTable (
        $columnFavId INTEGER PRIMARY KEY,
        $columnFavName TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $mealPlanTable (
        $columnMealId INTEGER PRIMARY KEY,
        $columnRecipe TEXT NOT NULL,
        $columnDay TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE $favoritesTable ADD COLUMN day TEXT');
    }
  }

  // Insert a recipe
  Future<int> insertRecipe(Map<String, dynamic> row) async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.insert(table, row);
  }

  // Insert a grocery item
  Future<int> insertGroceryItem(Map<String, dynamic> row) async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.insert(groceryTable, row);
  }

  // Insert a favorite recipe
  Future<int> insertFavoriteRecipe(Map<String, dynamic> row) async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.insert(favoritesTable, row);
  }

  Future<int> insertMealPlan(String recipeName, String day) async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.insert(mealPlanTable, {
      columnRecipe: recipeName, // Save recipe
      columnDay: day,           // Save day
    });
  }

  // Query all recipes
  Future<List<Map<String, dynamic>>> queryAllRecipes() async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.query(table);
  }

  // Query all grocery items
  Future<List<Map<String, dynamic>>> queryAllGroceryItems() async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.query(groceryTable);
  }

  // Query all favorite recipes
  Future<List<Map<String, dynamic>>> queryAllFavoriteRecipes() async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient.query(favoritesTable); // Query the favorites table
  }

  Future<Map<String, String>> getMealPlan() async {
  var dbClient = await db;
  final List<Map<String, dynamic>> results = await dbClient.query(mealPlanTable);

  return Map.fromIterable(results,
    key: (e) => e['day'], 
    value: (e) => e['recipe']
  );
}

  // Delete a grocery item by ID
  Future<int> deleteGroceryItem(int id) async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient
        .delete(groceryTable, where: '$columnGroceryId = ?', whereArgs: [id]);
  }

  Future<int> deleteAllGroceryItems() async {
    var dbClient = await db; // Initialize the database
    return await dbClient
        .delete(groceryTable); // Replace 'grocery_items' with your table name
  }

  // Delete all favorite recipes
  Future<int> deleteAllFavoriteRecipes() async {
    var dbClient = await db; // Ensure db is initialized before use
    return await dbClient
        .delete(favoritesTable); // Delete all rows from the favorites table
  }
}
