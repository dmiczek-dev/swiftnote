import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swiftnote/models/category.dart';
import 'package:swiftnote/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String categoryTable = 'category_table';
  String colCatId = 'id';
  String colCatName = 'name';

  String noteTable = 'note_table';
  String colNoteId = 'id';
  String colNoteTitle = 'title';
  String colNoteDesc = 'description';
  String colNoteDate = 'date';
  String colNoteCatId = 'catId';

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
        'CREATE TABLE $categoryTable($colCatId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colCatName TEXT)');
    await db.execute(
        'CREATE TABLE $noteTable($colNoteId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colNoteTitle TEXT, $colNoteDesc TEXT, $colNoteDate TEXT, $colNoteCatId INTEGER)');
  }

  // CRUD CATEGORY

  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await this.database;
    var result = await db.query(categoryTable);
    return result;
  }

  Future<Map<String, dynamic>> getCategoryMap(int id) async {
    Database db = await this.database;
    var result =
        await db.query(categoryTable, where: '$colCatId = ?', whereArgs: [id]);
    return result[0];
  }

  Future<int> insertCategory(Category category) async {
    Database db = await this.database;
    var result = await db.insert(categoryTable, category.toMap());
    return result;
  }

  Future<int> updateCategory(Category category) async {
    Database db = await this.database;
    var result = await db.update(categoryTable, category.toMap(),
        where: '$colCatId = ?', whereArgs: [category.id]);
    return result;
  }

  Future<int> deleteCategory(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $categoryTable WHERE $colCatId = $id');
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

  Future<Category> getCategoryById(int id) async {
    var categoryMap = await getCategoryMap(id);
    return Category.fromMapObject(categoryMap);
  }

  // CRUD NOTE

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colNoteDate ASC');
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteListMap = await getNoteMapList();
    int count = noteListMap.length;
    List<Note> noteList = List<Note>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteListMap[i]));
    }

    return noteList;
  }
}
