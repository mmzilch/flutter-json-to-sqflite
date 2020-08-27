import 'package:flutter_healthy_fitness/model/foods_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _database;
  static final DatabaseHelper instance = DatabaseHelper._instance();
  DatabaseHelper._instance();

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  _initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path + 'healthyfitness.db');
    final healthyFitnessDB =
        await openDatabase(path, version: 1,onOpen: (database){}, onCreate: _createDB);
    return healthyFitnessDB;
  }

  String foodTable = 'food_table';
  String foodId = 'food_id';
  String foodName = 'food_name';
  String calories = 'calories';
  String foodImage = 'food_image';
  String category = 'category';

  String categoryTable = 'category_table';
  String categoryId = 'category_id';
  String categoryName = 'category_name';
  String categoryImage = 'category_image';

  void _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE $foodTable (
        $foodId INTEGER,
        $foodName TEXT,
        $calories TEXT,
        $foodImage TEXT,
        $category TEXT,
        FOREIGN KEY($category) REFERENCES $categoryTable ($categoryName) ON DELETE NO ACTION ON UPDATE NO ACTION
      )''');
    await db.execute('''CREATE TABLE $categoryTable(
        $categoryId INTEGER,
        $categoryName TEXT,
        $categoryImage TEXT
      )''');
  }

  createFood(Foods food) async {
    await deleteAllFood();
    Database db = await this.database;
    final res = await db.insert(
      '$foodTable', 
    food.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    print("createfoodresult>>>"+res.toString());
    return res;
  }

  Future<int> deleteAllFood() async {
    Database db = await this.database;
    final res = await db.rawDelete('DELETE FROM $foodTable');
    return res;
  }

  Future<List<Foods>> getAllFoodfromDb() async {
    Database db = await database;
    final res = await db.rawQuery('SELECT * FROM food_table');
    print("res>>>"+res.length.toString());
    List<Foods> list = res.isNotEmpty ? res.map((e) => Foods.fromJson(e)).toList() : [];
    print("getallfoodlist>>>$list");
    return list;
  }

  Future<Foods> getFoodWithId(int id) async {
    final db = await database;
    var response = await db.query("food_table", where: "food_id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Foods.fromJson(response.first) : null;
  }

   deleteFoodWithId(int id) async {
    final db = await database;
    return db.delete("food_table", where: "food_id = ?", whereArgs: [id]);
  }

  updateFood(Foods food) async {
    final db = await database;
    var response = await db.update("food_table", food.toJson(),
        where: "id = ?", whereArgs: [food.foodId]);
    return response;
  }

}
