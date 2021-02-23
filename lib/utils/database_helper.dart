import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swiftnote/models/category.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String categoryTable = 'category_table';
  String colId = 'id';
  String colName = 'name';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $categoryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT)');
  }

  // CRUD

  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await this.database;
    var result = await db.query(categoryTable);
    return result;
  }

  Future<int> insertCategory(Category category) async {
    Database db = await this.database;
    var result = await db.insert(categoryTable, category.toMap());
    return result;
  }

  Future<int> updateCategory(Category category) async {
    Database db = await this.database;
    var result = await db.update(categoryTable, category.toMap(),
        where: '$colId = ?', whereArgs: [category.id]);
    return result;
  }

  Future<int> deleteCategory(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $categoryTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCategoryCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> counter =
        await db.rawQuery('SELECT COUNT (*) FROM $categoryTable');
    int result = Sqflite.firstIntValue(counter);
    return result;
  }

  Future<List<Category>> getCategoryList() async {
    var categoryListMap = await getCategoryMapList();
    int count = categoryListMap.length;
    List<Category> categoryList = List<Category>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      categoryList.add(Category.fromMapObject(categoryListMap[i]));
    }
    return categoryList;
  }
}
